//
//  BMNewsManager.m
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMNewsManager.h"

#import "BMUtils.h"

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

- (void)configInit:(void (^)(void))finished
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:_configFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        NSError *error;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
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
            
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                NewsCategory *newsCategory = [self createNewsCategory:obj context:temporaryContext];
                newsCategory.cid = [NSNumber numberWithInteger:idx];
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
- (void)createConfigFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [self managedObjectContext];
    }
    
}

- (void)createNewsFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context
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
        [self createNews:newsInfo context:context];
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
            [medias addObject:media];
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
    
    NSArray *array = dic[@"sizes"];
    if (array && (NSNull *)array != [NSNull null]) {
        for (NSDictionary *obj in array) {
            NSString *size = obj[@"name"];
            if ([size isEqualToString:@"medium"]) {
                media.small = obj[@"url"];
                media.small_width = obj[@"width"];
                media.small_height = obj[@"height"];
                continue;
            }
            if ([size isEqualToString:@"full"]) {
                media.large = obj[@"url"];
                media.large_width = obj[@"width"];
                media.large_height = obj[@"height"];
                continue;
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
    NSString *cid = dic[@"category_id"];
    
    if (!cid || (NSNull *)cid == [NSNull null]) {
        NSLog(@"NewsCategory: cid null");
        return nil;
    }
    
    NewsCategory *newsCategory = [self getNewsCategoryById:cid context:context];
    
    if (!newsCategory) {
        newsCategory = [NSEntityDescription insertNewObjectForEntityForName:NewsCategory_Entity inManagedObjectContext:context];
        newsCategory.category_id = cid;
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
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %i", kCategoryId, cid]];
    
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
    
    NSString *name = dic[@"nicename"];
    if (name && (NSNull *)name != [NSNull null]) {
        user.name = name;
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

#pragma mark - Networking

- (AFHTTPRequestOperation *)getDownloadList:(NSUInteger)type
                                       page:(NSUInteger)page
                                    success:(void (^)(NSArray *array))success
                                    failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
            
            NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            temporaryContext.parentContext = [self managedObjectContext];
            
            [temporaryContext performBlock:^{
                [self createNewsFromNetworking:responseObject context:temporaryContext];
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
    
    AFHTTPRequestOperation *op = [_manager GET:@"http://115.29.43.107/site/wp_api/v1/posts" parameters:nil success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)getCommentsByNews:(News *)news
                                      success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
            
//            __block NSArray *array = (NSArray *)responseObject;
//            NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
//            NSError *error;
//            NSString *cacheStr = [NSString stringWithContentsOfFile:_configFilePath encoding:NSUTF8StringEncoding error:&error];
//            if (error) {
//                NSLog(@"config error: %@", error.localizedDescription);
//                abort();
//            }
//            
//            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            if (![str isEqualToString:cacheStr]) {
//                NSError *e;
//                [str writeToFile:_configFilePath atomically:YES encoding:NSUTF8StringEncoding error:&e];
//                if (e) {
//                    NSLog(@"config error: %@", e.localizedDescription);
//                    abort();
//                }
//                
//                NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//                temporaryContext.parentContext = [self managedObjectContext];
//                
//                [temporaryContext performBlock:^{
//                    
//                    NSArray *nCategoryArray = [self getAllNewsCategory:temporaryContext];
//                    [nCategoryArray enumerateObjectsUsingBlock:^(NewsCategory *obj, NSUInteger idx, BOOL *stop){
//                        [temporaryContext deleteObject:obj];
//                    }];
//                    
//                    array = (NSArray *)responseObject;
//                    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
//                        NewsCategory *newsCategory = [self createNewsCategory:obj context:temporaryContext];
//                        newsCategory.cid = [NSNumber numberWithInteger:idx];
//                    }];
//                    
//                    [self saveContext:temporaryContext];
//                    // save parent to disk asynchronously
//                    [temporaryContext.parentContext performBlock:^{
//                        [self saveContext:temporaryContext.parentContext];
//                        if (success) {
//                            success();
//                        }
//                    }];
//                }];
//            }
//            else {
//                if (success) {
//                    success();
//                }
//            }
//        }
//        else {
//            if (success) {
//                success();
//            }
        }
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager GET:[NSString stringWithFormat:@"http://115.29.43.107/site/wp_api/v1/post/%@/comments", news.nid] parameters:nil success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)getConfigSuccess:(void (^)(void))success
                                     failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
//            NSLog(@"%@", responseObject);
            
            __block NSArray *array = (NSArray *)responseObject;
            NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
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
                    
                    array = (NSArray *)responseObject;
                    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                        NewsCategory *newsCategory = [self createNewsCategory:obj context:temporaryContext];
                        newsCategory.cid = [NSNumber numberWithInteger:idx];
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
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager GET:@"http://115.29.43.107/site/api/v1/index.php/category/getCategoryLeft" parameters:nil success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

@end
