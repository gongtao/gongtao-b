//
//  BMNewsManager.m
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMNewsManager.h"

#import "BMUtils.h"

#import <SDImageCache.h>

#import <TencentOpenAPI/QQApiInterface.h>

#import <TencentOpenAPI/TencentOAuth.h>

@interface BMNewsManager ()
{
    AFHTTPRequestOperationManager *_manager;
}

@end

@implementation BMNewsManager

+ (BMNewsManager *)sharedManager
{
    static BMNewsManager *sharedManagerInstance = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[BMNewsManager alloc] init];
    });
    
    return sharedManagerInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _configFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"config.json"];
        
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:kBaseURL];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
        [_manager.operationQueue setMaxConcurrentOperationCount:3];
        
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024
                                                             diskCapacity:40 * 1024 * 1024
                                                                 diskPath:nil];
        [NSURLCache setSharedURLCache:URLCache];
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    id delegate = [[UIApplication sharedApplication] delegate];
    return [delegate managedObjectContext];
}

- (BOOL)saveContext:(NSManagedObjectContext *)context
{
    BOOL result = YES;
    NSError *error;
    
    if (![context hasChanges]) {
        return result;
    }
    
    result = [context save:&error];
    
    if (error) {
        NSLog(@"save context error: %@", error);
        abort();
    }
    
    return result;
}

- (BOOL)saveContext
{
    return [self saveContext:[self managedObjectContext]];
}

- (void)configInit:(void (^)(void))finished
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:_configFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            NSLog(@"config error: %@", error.localizedDescription);
            abort();
        }
        
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *e;
        [jsonString writeToFile:_configFilePath atomically:YES encoding:NSUTF8StringEncoding error:&e];
        if (e) {
            NSLog(@"config error: %@", e);
            abort();
        }
        
        NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        temporaryContext.parentContext = [self managedObjectContext];
        
        [temporaryContext performBlock:^{
            
            NSArray *nCategoryArray = [self getAllNewsCategory:temporaryContext];
            [nCategoryArray enumerateObjectsUsingBlock:^(NewsCategory *obj, NSUInteger idx, BOOL *stop){
                [temporaryContext deleteObject:obj];
            }];
            
            NSArray *array = dic[@"left"];
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                NewsCategory *newsCategory = [self createNewsCategory:obj context:temporaryContext];
                newsCategory.isHead = [NSNumber numberWithBool:NO];
                NSLog(@"%@", obj);
            }];
            
            array = dic[@"head"];
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                NewsCategory *newsCategory = [self createNewsCategory:obj context:temporaryContext];
                newsCategory.isHead = [NSNumber numberWithBool:YES];
                NSLog(@"%@", obj);
            }];
            
            [self saveContext:temporaryContext];
            // save parent to disk asynchronously
            [temporaryContext.parentContext performBlock:^{
                [self saveContext:temporaryContext.parentContext];
                if (finished) {
                    finished();
                }
            }];
        }];
    }
    else {
        if (finished) {
            finished();
        }
    }
}

#pragma mark - Interface

- (void)shareNews:(News *)news delegate:(id<UMSocialUIDelegate>)delegate
{
    int length = 100-news.url.length;
    NSString *content = news.title;
    if (length < content.length) {
        content = [NSString stringWithFormat:@"%@...", [content substringToIndex:length-1]];
    }
    NSString *shareText = [NSString stringWithFormat:@"我在看芝麻短片：%@ 网址：%@", content, news.url];
    
    [UMSocialConfig setWXAppId:kWXAppKey url:news.url];
    
    [UMSocialConfig setQQAppId:@"101028148" url:news.url importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    
    [UMSocialConfig setShareQzoneWithQQSDK:YES url:news.url importClasses:@[[QQApiInterface class],[TencentOAuth class],[TCUploadPicDic class],[TCAddShareDic class]]];
    
    UIImage *image = nil;
    if (news.medias.count > 0) {
        NSString *imageKey = [(Media *)news.medias[0] small];
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageKey];
    }
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [UMSocialSnsService presentSnsIconSheetView:vc
                                         appKey:nil
                                      shareText:shareText
                                     shareImage:image
                                shareToSnsNames:nil
                                       delegate:delegate];
}

- (void)collectNews:(News *)news operation:(BOOL)isAdd
{
    User *user = [self getMainUser];
    BOOL isCollect = NO;
    for (User *obj in news.collectUsers) {
        NSLog(@"uid %@ %@", obj.uid, user.uid);
        if (user.uid.integerValue == obj.uid.integerValue) {
            isCollect = YES;
            break;
        }
    }
    if (isAdd && !isCollect) {
        [news addCollectUsersObject:user];
        
        [self collectToSite:news.nid.integerValue
                     action:@"add"
                    success:^(void){}
                    failure:^(NSError *error){}];
    }
    else if (!isAdd && isCollect) {
        [news removeCollectUsersObject:user];
        
        [self collectToSite:news.nid.integerValue
                     action:@"remove"
                    success:^(void){}
                    failure:^(NSError *error){}];
    }
    else {
        return;
    }
    [self saveContext];
}

- (void)createConfigFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [self managedObjectContext];
    }
    
}

- (void)createNewsFromNetworking:(NSDictionary *)dic newsCategory:(NewsCategory *)newsCategory context:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [self managedObjectContext];
    }
    NSArray *array = dic[@"posts"];
    if (!array || (NSNull *)array == [NSNull null]) {
        return;
    }
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSDictionary *newsInfo = (NSDictionary *)obj;
        News *news = [self createNews:newsInfo context:context];
        NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithOrderedSet:newsCategory.list];
        [set addObject:news];
        newsCategory.list = set;
    }];
}

- (void)createSearchNewsFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [self managedObjectContext];
    }
    NSArray *array = dic[@"posts"];
    if (!array || (NSNull *)array == [NSNull null]) {
        return;
    }
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSDictionary *newsInfo = (NSDictionary *)obj;
        News *news = [self createNews:newsInfo context:context];
        news.isSearch = [NSNumber numberWithBool:YES];
    }];
}

- (void)createSearchUsersFromNetworking:(NSArray *)array context:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [self managedObjectContext];
    }
    if (!array || (NSNull *)array == [NSNull null]) {
        return;
    }
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
        User *user = [self createUser:obj context:context];
        user.isSearch = [NSNumber numberWithBool:YES];
    }];
}

- (void)createCommentsFromNetworking:(NSDictionary *)dic news:(News *)news context:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [self managedObjectContext];
    }
    NSArray *array = dic[@"comments"];
    if (!array || (NSNull *)array == [NSNull null]) {
        return;
    }
    News *newsNew = [self getNewsById:news.nid.integerValue context:context];
    NSMutableArray *comments = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
        Comment *comment = [self createComment:obj context:context];
        [comments addObject:comment];
    }];
    newsNew.comments = [[NSOrderedSet alloc] initWithArray:comments];
}

- (void)clearCacheData:(void (^)(void))finished
{
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = [self managedObjectContext];
    
    [temporaryContext performBlock:^(void){
        NSArray *array = [self getAllNews:temporaryContext];
        User *user = [self getMainUserWithContext:temporaryContext];
        [array enumerateObjectsUsingBlock:^(News *obj, NSUInteger idx, BOOL *stop){
            obj.category = [NSOrderedSet orderedSet];
            if (![obj.collectUsers containsObject:user]) {
                [temporaryContext deleteObject:obj];
            }
        }];
        [self saveContext:temporaryContext];
        // save parent to disk asynchronously
        [temporaryContext.parentContext performBlock:^{
            [self saveContext:temporaryContext.parentContext];
            if (finished) {
                finished();
            }
        }];
    }];
}

- (void)clearSearchData:(void (^)(void))finished
{
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = [self managedObjectContext];
    
    [temporaryContext performBlock:^(void){
        //清除News
        NSArray *array = [self getAllSearchNews:temporaryContext];
        [array enumerateObjectsUsingBlock:^(News *obj, NSUInteger idx, BOOL *stop){
            obj.isSearch = [NSNumber numberWithBool:NO];
            if (obj.category.count==0 && obj.collectUsers.count==0) {
                [temporaryContext deleteObject:obj];
            }
        }];
        //清除User
        array = [self getAllSearchUsers:temporaryContext];
        [array enumerateObjectsUsingBlock:^(User *obj, NSUInteger idx, BOOL *stop){
            obj.isSearch = [NSNumber numberWithBool:NO];
            if (obj.news.count==0 &&
                obj.collectNews.count==0 &&
                obj.comments.count==0 &&
                obj.replyComment.count==0) {
                [temporaryContext deleteObject:obj];
            }
        }];
        [self saveContext:temporaryContext];
        // save parent to disk asynchronously
        [temporaryContext.parentContext performBlock:^{
            [self saveContext:temporaryContext.parentContext];
            if (finished) {
                finished();
            }
        }];
    }];
}

#pragma mark - Database

//News
- (News *)createNews:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    NSNumber *nid = dic[@"id"];
    
    if (!nid || (NSNull *)nid == [NSNull null]) {
        NSLog(@"News: nid null");
        return nil;
    }
    
    News *news = [self getNewsById:nid.integerValue context:context];
    
    if (!news) {
        news = [NSEntityDescription insertNewObjectForEntityForName:News_Entity inManagedObjectContext:context];
        news.nid = nid;
    }
    
    NSString *title = dic[@"title"];
    if (title && (NSNull *)title != [NSNull null]) {
        news.title = title;
        CGSize size = [title sizeWithFont:Font_NewsTitle constrainedToSize:CGSizeMake(294.0, NSUIntegerMax)];
        news.text_height = [NSNumber numberWithFloat:size.height];
    }
    
    NSString *name = dic[@"name"];
    if (name && (NSNull *)name != [NSNull null]) {
        news.name = name;
    }
    
    NSString *url = dic[@"permalink"];
    if (url && (NSNull *)url != [NSNull null]) {
        news.url = url;
    }
    
    NSNumber *comment_count = dic[@"comment_count"];
    if (comment_count && (NSNull *)comment_count != [NSNull null]) {
        news.comment_count = comment_count;
    }
    
    NSNumber *like_count = dic[@"like_count"];
    if (like_count && (NSNull *)like_count != [NSNull null]) {
        news.like_count = like_count;
    }
    
    NSNumber *fa_count = dic[@"fa_count"];
    if (fa_count && (NSNull *)fa_count != [NSNull null]) {
        news.fa_count = fa_count;
    }
    
    NSNumber *share_count = dic[@"share_count"];
    if (share_count && (NSNull *)share_count != [NSNull null]) {
        news.share_count = share_count;
    }
    
    NSString *date = dic[@"date"];
    if (date && (NSNull *)date != [NSNull null]) {
        news.ndate = [BMUtils dateFromString:date];
    }
    
    NSDictionary *author = dic[@"author"];
    if (author && (NSNull *)author != [NSNull null]) {
        news.user = [self createUser:author context:context];
    }
    
    NSArray *mediaArray= dic[@"media"];
    NSMutableArray *medias = [[NSMutableArray alloc] init];
    if (mediaArray && (NSNull *)mediaArray != [NSNull null]) {
        [mediaArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            Media *media = [self createMedia:obj context:context];
            if (media) {
                [medias addObject:media];
            }
        }];
        news.medias = [[NSOrderedSet alloc] initWithArray:medias];
    }
    
    CGFloat h = 0.0;
    if (medias.count == 1) {
        Media *media = medias[0];
        h = media.small_height.floatValue;
        if (h > kCellSingleImgHeight) {
            h = kCellSingleImgHeight;
        }
    }
    else if (medias.count>1 && medias.count<3) {
        h = kCellMediumImgHeight;
    }
    else if (medias.count>2 && medias.count<5) {
        h = kCellMediumImgHeight*2+4.0;
    }
    else if (medias.count>4) {
        int count = medias.count/3+((medias.count%3==0)?0:1);
        h = (kCellSmallImgHeight+3.0)*count-3.0;
    }
    news.image_height = [NSNumber numberWithFloat:h];
    
    return news;
}

- (News *)getNewsById:(NSUInteger)nid context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:context];
    
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %i", kNid, nid]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results[0];
    }
    return nil;
}

- (NSArray *)getAllNews:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results;
    }
    return nil;
}

- (NSArray *)getAllSearchNews:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", kIsNewsSearch, [NSNumber numberWithBool:YES]]];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results;
    }
    return nil;
}

- (Media *)createMedia:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    NSNumber *mid = dic[@"id"];
    
    if (!mid || (NSNull *)mid == [NSNull null]) {
        NSLog(@"News: nid null");
        return nil;
    }
    
    Media *media = [self getMediaById:mid.integerValue context:context];
    
    if (!media) {
        media = [NSEntityDescription insertNewObjectForEntityForName:Media_Entity inManagedObjectContext:context];
        media.mid = mid;
    }
    
    NSString *type = dic[@"mime_type"];
    if (type && (NSNull *)type != [NSNull null]) {
        media.type = type;
    }
    
    if ([type rangeOfString:@"image"].location == NSNotFound) {
        NSString *url = dic[@"url"];
        url = [url stringByReplacingOccurrencesOfString:@"player.youku.com/player.php/sid/" withString:@"v.youku.com/player/getRealM3U8/vid/"];
        media.url = [url stringByReplacingOccurrencesOfString:@"/v.swf" withString:@"/type/video.m3u8"];
        media.small_width = [NSNumber numberWithFloat:160.0];
        media.small_height = [NSNumber numberWithFloat:120.0];
        media.large_width = [NSNumber numberWithFloat:160.0];
        media.large_height = [NSNumber numberWithFloat:120.0];
    }
    else {
        NSArray *array = dic[@"sizes"];
        if (array && (NSNull *)array != [NSNull null]) {
            for (NSDictionary *obj in array) {
                NSString *size = obj[@"name"];
                if (!media.small && ([size isEqualToString:@"medium"] || [size isEqualToString:@"hot"] || [size isEqualToString:@"show"])) {
                    media.small = obj[@"url"];
                    media.small_width = obj[@"width"];
                    media.small_height = obj[@"height"];
                    continue;
                }
                if (!media.large && [size isEqualToString:@"full"]) {
                    media.large = obj[@"url"];
                    media.large_width = obj[@"width"];
                    media.large_height = obj[@"height"];
                    continue;
                }
            }
        }
    }
    
    return media;
}

- (Media *)getMediaById:(NSUInteger)mid context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:Media_Entity inManagedObjectContext:context];
    
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %i", kMid, mid]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results[0];
    }
    return nil;
}

//NewsCategory
- (NewsCategory *)createNewsCategory:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    NSNumber *cid = dic[@"category_id"];
    
    if (!cid || (NSNull *)cid == [NSNull null]) {
        NSLog(@"NewsCategory: cid null");
        return nil;
    }
    
    NSString *cidStr = [NSString stringWithFormat:@"%@", cid];
    NewsCategory *newsCategory = [self getNewsCategoryById:cidStr context:context];
    
    if (!newsCategory) {
        newsCategory = [NSEntityDescription insertNewObjectForEntityForName:NewsCategory_Entity inManagedObjectContext:context];
        newsCategory.category_id = cidStr;
    }
    
    NSString *name = dic[@"name"];
    if (name && (NSNull *)name != [NSNull null]) {
        newsCategory.cname = name;
    }
    
    return newsCategory;
}

- (NewsCategory *)getNewsCategoryById:(NSString *)cid context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NewsCategory_Entity inManagedObjectContext:context];
    
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", kCategoryId, cid]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results[0];
    }
    return nil;
}

- (NSArray *)getAllNewsCategory:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NewsCategory_Entity inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results;
    }
    return nil;
}

- (User *)createUser:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    NSNumber *uid = dic[@"id"];
    
    if (!uid || (NSNull *)uid == [NSNull null]) {
        NSLog(@"User: uid null");
        return nil;
    }
    
    User *user = [self getUserById:uid.integerValue context:context];
    
    if (!user) {
        user = [NSEntityDescription insertNewObjectForEntityForName:User_Entity inManagedObjectContext:context];
        user.uid = uid;
    }
    
    NSString *name = dic[@"display_name"];
    if (name && (NSNull *)name != [NSNull null] && name.length > 0) {
        user.name = name;
    }
    else {
        user.name = @"匿名用户";
    }
    
    NSArray *avatar = dic[@"avatar"];
    if (avatar && (NSNull *)avatar != [NSNull null] && avatar.count>0) {
        user.avatar = avatar[0][@"url"];
    }
    
    return user;
}

- (User *)getUserById:(NSUInteger)uid context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:User_Entity inManagedObjectContext:context];
    
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %i", kUid, uid]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results[0];
    }
    return nil;
}

- (NSArray *)getAllSearchUsers:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:User_Entity inManagedObjectContext:context];
    
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", kIsUserSearch, [NSNumber numberWithBool:YES]]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results;
    }
    return nil;
}

- (User *)getMainUserWithContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:User_Entity inManagedObjectContext:context];
    
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", kIsMainUser, [NSNumber numberWithBool:YES]]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results[0];
    }
    return nil;
}

- (User *)getMainUser
{
    return [self getMainUserWithContext:self.managedObjectContext];
}

- (Comment *)createComment:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    NSNumber *cid = dic[@"id"];
    
    if (!cid || (NSNull *)cid == [NSNull null]) {
        NSLog(@"Comment: cid null");
        return nil;
    }
    
    Comment *comment = [self getCommentById:cid.integerValue context:context];
    
    if (!comment) {
        comment = [NSEntityDescription insertNewObjectForEntityForName:Comment_Entity inManagedObjectContext:context];
        comment.cid = cid;
    }
    
    NSString *content = dic[@"content"];
    if (content && (NSNull *)content != [NSNull null]) {
        comment.content = content;
        CGSize size = [content sizeWithFont:Font_NewsTitle constrainedToSize:CGSizeMake(257.0, NSUIntegerMax)];
        comment.height = [NSNumber numberWithFloat:size.height];
    }
    
    NSString *date = dic[@"date"];
    if (date && (NSNull *)date != [NSNull null]) {
        comment.date = [BMUtils dateFromString:date];
    }
    
    //用户
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
    NSNumber *uid = dic[@"user"];
    if (uid && (NSNull *)uid != [NSNull null]) {
        userDic[@"id"] = uid;
    }
    
    NSString *name = dic[@"author"];
    if (name && (NSNull *)name != [NSNull null]) {
        userDic[@"display_name"] = name;
    }
    
    NSArray *avatar = dic[@"avatar"];
    if (avatar && (NSNull *)avatar != [NSNull null]) {
        userDic[@"avatar"] = avatar;
    }
    
    comment.author = [self createUser:userDic context:context];
    
    //回复用户
    userDic = [[NSMutableDictionary alloc] init];
    NSDictionary *replyUserDic = dic[@"parent_info"];
    
    NSString *reply_uid = replyUserDic[@"user"];
    if (reply_uid && (NSNull *)reply_uid != [NSNull null]) {
        userDic[@"id"] = [NSNumber numberWithInteger:[reply_uid integerValue]];
    }
    
    NSString *reply_name = replyUserDic[@"author"];
    if (reply_name && (NSNull *)reply_name != [NSNull null]) {
        userDic[@"display_name"] = reply_name;
    }
    comment.replyUser = [self createUser:userDic context:context];
    
    return comment;
}

- (Comment *)getCommentById:(NSUInteger)cid context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:Comment_Entity inManagedObjectContext:context];
    
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %i", kCommentId, cid]];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error && results.count > 0) {
        return results[0];
    }
    return nil;
}

#pragma mark - Networking

- (AFHTTPRequestOperation *)getDownloadList:(NSString *)cid
                                       page:(NSUInteger)page
                                    success:(void (^)(NSArray *array))success
                                    failure:(void (^)(NSError *error))failure
{
    NSDictionary *param = @{@"cat": cid,
                            @"paged": [NSNumber numberWithInt:page],
                            @"per_page": [NSNumber numberWithInt:10]};
    
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
            
            NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            temporaryContext.parentContext = [self managedObjectContext];
            
            [temporaryContext performBlock:^{
                NewsCategory *newsCategory = [self getNewsCategoryById:cid context:temporaryContext];
                
                if (1 == page) {
                    newsCategory.list = [NSOrderedSet orderedSet];
                    newsCategory.refreshTime = [NSDate date];
                }
                
                [self createNewsFromNetworking:responseObject newsCategory:newsCategory context:temporaryContext];
                [self saveContext:temporaryContext];
                // save parent to disk asynchronously
                [temporaryContext.parentContext performBlock:^{
                    [self saveContext:temporaryContext.parentContext];
                    if (success) {
                        success(nil);
                    }
                }];
            }];
        }
        else {
            if (success) {
                success(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager GET:@"wp_api/v1/posts" parameters:param success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)getCommentsByNews:(News *)news
                                         page:(NSInteger)page
                                      success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
            
            NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            temporaryContext.parentContext = [self managedObjectContext];
            
            [temporaryContext performBlock:^{
                [self createCommentsFromNetworking:responseObject news:news context:temporaryContext];
                [self saveContext:temporaryContext];
                // save parent to disk asynchronously
                [temporaryContext.parentContext performBlock:^{
                    [self saveContext:temporaryContext.parentContext];
                    if (success) {
                        success();
                    }
                }];
            }];
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager GET:[NSString stringWithFormat:@"wp_api/v1/posts/%@/comments", news.nid] parameters:@{@"paged": [NSNumber numberWithInteger:page], @"per_page": [NSNumber numberWithInteger:10]} success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)getConfigSuccess:(void (^)(void))success
                                     failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
//            NSLog(@"%@", responseObject);
            
            __block NSDictionary *dic = (NSDictionary *)responseObject;
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSError *error;
            NSString *cacheStr = [NSString stringWithContentsOfFile:_configFilePath encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"config error: %@", error.localizedDescription);
                abort();
            }
            
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (![str isEqualToString:cacheStr]) {
                NSError *e;
                [str writeToFile:_configFilePath atomically:YES encoding:NSUTF8StringEncoding error:&e];
                if (e) {
                    NSLog(@"config error: %@", e.localizedDescription);
                    abort();
                }
                
                NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                temporaryContext.parentContext = [self managedObjectContext];
                
                [temporaryContext performBlock:^{
                    
                    NSArray *nCategoryArray = [self getAllNewsCategory:temporaryContext];
                    [nCategoryArray enumerateObjectsUsingBlock:^(NewsCategory *obj, NSUInteger idx, BOOL *stop){
                        [temporaryContext deleteObject:obj];
                    }];
                    
                    NSArray *array = (NSArray *)responseObject[@"left"];
                    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                        NewsCategory *newsCategory = [self createNewsCategory:obj context:temporaryContext];
                        newsCategory.isHead = [NSNumber numberWithBool:NO];
                    }];
                    
                    array = (NSArray *)responseObject[@"head"];
                    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                        NewsCategory *newsCategory = [self createNewsCategory:obj context:temporaryContext];
                        newsCategory.isHead = [NSNumber numberWithBool:YES];
                    }];
                    
                    [self saveContext:temporaryContext];
                    // save parent to disk asynchronously
                    [temporaryContext.parentContext performBlock:^{
                        [self saveContext:temporaryContext.parentContext];
                        if (success) {
                            success();
                        }
                    }];
                }];
            }
            else {
                if (success) {
                    success();
                }
            }
        }
        else {
            if (success) {
                success();
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"%@", operation.responseString);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager GET:@"api/v1/index.php/category/getCategoryList" parameters:nil success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)userLogin:(NSDictionary *)param
                              success:(void (^)(User *user))success
                              failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
            
            NSString *token = responseObject[@"token"];
            if (token) {
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:kLoginToken];
                NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                temporaryContext.parentContext = [self managedObjectContext];
                
                [temporaryContext performBlock:^{
                    User *user = [self createUser:responseObject context:temporaryContext];
                    user.isMainUser = [NSNumber numberWithBool:YES];
                    [self saveContext:temporaryContext];
                    // save parent to disk asynchronously
                    [temporaryContext.parentContext performBlock:^{
                        [self saveContext:temporaryContext.parentContext];
                        User *user = [self getMainUserWithContext:temporaryContext.parentContext];
                        if (success) {
                            success(user);
                        }
                    }];
                }];
            }
            else {
                if (failure) {
                    failure(nil);
                }
            }
        }
        else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"data: %@", operation.responseString);
        if (failure) {
            failure(error);
        }
    };
    AFHTTPRequestOperation *op = [_manager POST:@"wp_api/v1/users/login" parameters:param success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    NSLog(@"param: %@", param);
    return op;
}

- (AFHTTPRequestOperation *)shareToSite:(NSInteger)postId
                                success:(void (^)(void))success
                                failure:(void (^)(NSError *error))failure
{
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = [self managedObjectContext];
    
    [temporaryContext performBlock:^{
        News *news = [self getNewsById:postId context:temporaryContext];
        NSInteger shareNum = news.share_count.integerValue;
        news.share_count = [NSNumber numberWithInteger:shareNum+1];
        [self saveContext:temporaryContext];
        // save parent to disk asynchronously
        [temporaryContext.parentContext performBlock:^{
            [self saveContext:temporaryContext.parentContext];
        }];
    }];
    
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        NSNumber *errCode = responseObject[@"errCode"];
        if (0 == errCode.integerValue) {
            if (success) {
                success();
            }
        }
        else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"data: %@", operation.responseString);
        if (failure) {
            failure(error);
        }
    };
    AFHTTPRequestOperation *op = [_manager POST:@"api/v1/index.php/post/doShareCallback" parameters:@{@"post_id": [NSNumber numberWithInteger:postId]} success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)dingToSite:(NSInteger)postId
                                success:(void (^)(void))success
                                failure:(void (^)(NSError *error))failure
{
    
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = [self managedObjectContext];
    
    [temporaryContext performBlock:^{
        News *news = [self getNewsById:postId context:temporaryContext];
        NSInteger likeNum = news.like_count.integerValue;
        news.like_count = [NSNumber numberWithInteger:likeNum+1];
        [self saveContext:temporaryContext];
        // save parent to disk asynchronously
        [temporaryContext.parentContext performBlock:^{
            [self saveContext:temporaryContext.parentContext];
            if (success) {
                success();
            }
        }];
    }];
    
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        NSNumber *errCode = responseObject[@"errCode"];
        if (0 == errCode.integerValue) {
            if (success) {
                success();
            }
        }
        else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"data: %@", operation.responseString);
        if (failure) {
            failure(error);
        }
    };
    AFHTTPRequestOperation *op = [_manager POST:@"api/v1/index.php/post/doLike" parameters:@{@"post_id": [NSNumber numberWithInteger:postId]} success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)collectToSite:(NSInteger)postId
                                   action:(NSString *)action
                                  success:(void (^)(void))success
                                  failure:(void (^)(NSError *error))failure
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginToken];
    NSDictionary *param = @{@"post_id": [NSNumber numberWithInteger:postId],
                            @"token": token,
                            @"action": action};
    
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        NSNumber *errCode = responseObject[@"errCode"];
        if (0 == errCode.integerValue) {
            if (success) {
                success();
            }
        }
        else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"data: %@", operation.responseString);
        if (failure) {
            failure(error);
        }
    };
    AFHTTPRequestOperation *op = [_manager POST:@"api/v1/index.php/post/doFavirite" parameters:param success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)postComment:(NSInteger)postId
                                comment:(NSString *)comment
                           replyComment:(Comment *)replyComment
                                success:(void (^)(void))success
                                failure:(void (^)(NSError *error))failure
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginToken];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:postId], @"post_id", token, @"token", comment, @"comment", nil];
    if (replyComment) {
        [param setObject:replyComment.cid forKey:@"comment_parent"];
    }
    
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        NSNumber *errCode = responseObject[@"errCode"];
        if (0 == errCode.integerValue) {
            if (success) {
                success();
            }
        }
        else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"data: %@", operation.responseString);
        if (failure) {
            failure(error);
        }
    };
    AFHTTPRequestOperation *op = [_manager POST:@"wp_api/v1/comments/add" parameters:param success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)getUserInfoById:(NSInteger)uid
                                    success:(void (^)(NSString *des))success
                                    failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if (responseObject != [NSNull null]) {
            NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            temporaryContext.parentContext = [self managedObjectContext];
            
            [temporaryContext performBlock:^(void){
                [self createUser:responseObject context:temporaryContext];
                [self saveContext:temporaryContext];
                // save parent to disk asynchronously
                [temporaryContext.parentContext performBlock:^{
                    [self saveContext:temporaryContext.parentContext];
                    NSDictionary *meta = responseObject[@"meta"];
                    if (meta && (NSNull *)meta != [NSNull null]) {
                        if (success) {
                            success(meta[@"description"]);
                        }
                    }
                }];
            }];
        }
        else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"data: %@", operation.responseString);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager GET:[NSString stringWithFormat:@"wp_api/v1/users/%i", uid] parameters:nil success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)getSearchUsers:(NSString *)key
                                   success:(void (^)(void))success
                                   failure:(void (^)(NSError *error))failure
{
    NSDictionary *param = @{@"s": key};
    
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
            
            NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            temporaryContext.parentContext = [self managedObjectContext];
            
            [temporaryContext performBlock:^{
                [self createSearchUsersFromNetworking:responseObject context:temporaryContext];
                [self saveContext:temporaryContext];
                // save parent to disk asynchronously
                [temporaryContext.parentContext performBlock:^{
                    [self saveContext:temporaryContext.parentContext];
                    if (success) {
                        success();
                    }
                }];
            }];
        }
        else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager POST:@"wp_api/v1/users/search" parameters:param success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)getSearchNews:(NSString *)key
                                  success:(void (^)(void))success
                                  failure:(void (^)(NSError *error))failure
{
    NSDictionary *param = @{@"s": key};
    
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
            
            NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            temporaryContext.parentContext = [self managedObjectContext];
            
            [temporaryContext performBlock:^{
                [self createSearchNewsFromNetworking:responseObject context:temporaryContext];
                [self saveContext:temporaryContext];
                // save parent to disk asynchronously
                [temporaryContext.parentContext performBlock:^{
                    [self saveContext:temporaryContext.parentContext];
                    if (success) {
                        success();
                    }
                }];
            }];
        }
        else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager GET:@"wp_api/v1/posts" parameters:param success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)getSubmission:(NSString *)content
                                 imageNum:(NSArray *)imageArray
                                  success:(void (^)(void))success
                                  failure:(void (^)(NSError *error))failure
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginToken];
    NSDictionary *param = @{@"title": content,
                            @"token": token};
    
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
            if (success) {
                success();
            }
        }
        else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ %@", error, operation.responseString);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager POST:@"wp_api/v1/post/add"
                                     parameters:param
                      constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                          [imageArray enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL *stop){
                              NSError *error;
                              [formData appendPartWithFileURL:obj name:[NSString stringWithFormat:@"pic%i", idx+1] fileName:[obj lastPathComponent] mimeType:@"image/jpeg" error:&error];
//                              [formData appendPartWithFileURL:obj name:[NSString stringWithFormat:@"pic%i", idx+1] error:&error];
                              if (error) {
                                  NSLog(@"error:%@", error);
                              }
                              
                          }];
                      }
                                        success:requestSuccess
                                        failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

@end
