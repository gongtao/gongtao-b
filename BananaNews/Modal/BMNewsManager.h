//
//  BMNewsManager.h
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import <AFNetworking.h>

#import "News.h"

#import "Author.h"

#import "Media.h"

#import "NewsCategory.h"

#import "Comment.h"

#import "User.h"

#define News_Entity             @"News"
#define kNid                    @"nid"

#define Comment_Entity          @"Comment"
#define kCommentDate            @"date"

#define User_Entity             @"User"
#define kUid                    @"uid"

#define NewsCategory_Entity     @"NewsCategory"
#define kCategoryId             @"category_id"
#define kCid                    @"cid"

#define Media_Entity            @"Media"
#define kMid                    @"mid"
#define kSmall                  @"small"
#define kSmallWidth             @"small_width"
#define kSmallHeight            @"small_height"
#define kLarge                  @"large"
#define kLargeWidth             @"large_width"
#define kLargeHeight            @"large_height"

@interface BMNewsManager : NSObject
{
    NSString *_configFilePath;
}

+ (BMNewsManager *)sharedManager;

- (NSManagedObjectContext *)managedObjectContext;

- (BOOL)saveContext:(NSManagedObjectContext *)context;

- (void)configInit:(void (^)(void))finished;

//Interface

- (void)createConfigFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (void)createNewsFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

//Database

- (News *)createNews:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (News *)getNewsById:(NSUInteger)nid context:(NSManagedObjectContext *)context;

- (NSArray *)getAllNews:(NSManagedObjectContext *)context;

- (Media *)createMedia:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (Media *)getMediaById:(NSUInteger)mid context:(NSManagedObjectContext *)context;

- (NewsCategory *)createNewsCategory:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (NewsCategory *)getNewsCategoryById:(NSString *)cid context:(NSManagedObjectContext *)context;

- (NSArray *)getAllNewsCategory:(NSManagedObjectContext *)context;

- (User *)createUser:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (User *)getUserById:(NSUInteger)uid context:(NSManagedObjectContext *)context;

//Networking

- (AFHTTPRequestOperation *)getDownloadList:(NSUInteger)type
                                       page:(NSUInteger)page
                                    success:(void (^)(NSArray *array))success
                                    failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)getCommentsByNews:(News *)news
                                      success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)getConfigSuccess:(void (^)(void))success
                                     failure:(void (^)(NSError *error))failure;

@end
