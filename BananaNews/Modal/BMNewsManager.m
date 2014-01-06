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
    
    NSString *date = dic[@"date"];
    if (date && (NSNull *)date != [NSNull null]) {
        news.ndate = [BMUtils dateFromString:date];
    }
    
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

#pragma mark - Networking

- (AFHTTPRequestOperation *)getDownloadList:(NSUInteger)type
                                       page:(NSUInteger)page
                                    success:(void (^)(NSArray *array))success
                                    failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
//            NSLog(@"%@", responseObject);
            
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
    };
    
    void (^requestFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    };
    
    AFHTTPRequestOperation *op = [_manager GET:@"posts" parameters:nil success:requestSuccess failure:requestFailure];
    NSLog(@"request: %@", op.request.URL.absoluteString);
    return op;
}

- (AFHTTPRequestOperation *)getConfigSuccess:(void (^)(void))success
                                     failure:(void (^)(NSError *error))failure
{
    void (^requestSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != [NSNull null]) {
            NSLog(@"%@", responseObject);
            
            NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            temporaryContext.parentContext = [self managedObjectContext];
            
            [temporaryContext performBlock:^{
                
                NSArray *nCategoryArray = [self getAllNewsCategory:temporaryContext];
                [nCategoryArray enumerateObjectsUsingBlock:^(NewsCategory *obj, NSUInteger idx, BOOL *stop){
                    [temporaryContext deleteObject:obj];
                }];
                
                NSArray *array = (NSArray *)responseObject;
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
