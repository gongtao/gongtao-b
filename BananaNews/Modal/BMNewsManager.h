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

#import "UMSocial.h"

#import "News.h"

#import "Media.h"

#import "NewsCategory.h"

#import "Comment.h"

#import "User.h"

#define News_Entity             @"News"
#define kNid                    @"nid"

#define Comment_Entity          @"Comment"
#define kCommentDate            @"date"
#define kCommentId              @"cid"

#define User_Entity             @"User"
#define kUid                    @"uid"
#define kIsMainUser             @"isMainUser"

#define NewsCategory_Entity     @"NewsCategory"
#define kCategoryId             @"category_id"
#define kIsHead                 @"isHead"

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

- (BOOL)saveContext;

- (void)configInit:(void (^)(void))finished;

/** Interface **/

- (void)shareNews:(News *)news delegate:(id<UMSocialUIDelegate>)delegate;

- (void)collectNews:(News *)news operation:(BOOL)isAdd;

- (void)createConfigFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (void)createNewsFromNetworking:(NSDictionary *)dic newsCategory:(NewsCategory *)newsCategory context:(NSManagedObjectContext *)context;

- (void)createCommentsFromNetworking:(NSDictionary *)dic news:(News *)news context:(NSManagedObjectContext *)context;

/** Database **/

//News
- (News *)createNews:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (News *)getNewsById:(NSUInteger)nid context:(NSManagedObjectContext *)context;

- (NSArray *)getAllNews:(NSManagedObjectContext *)context;

//Media
- (Media *)createMedia:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (Media *)getMediaById:(NSUInteger)mid context:(NSManagedObjectContext *)context;

//NewsCategory
- (NewsCategory *)createNewsCategory:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (NewsCategory *)getNewsCategoryById:(NSString *)cid context:(NSManagedObjectContext *)context;

- (NSArray *)getAllNewsCategory:(NSManagedObjectContext *)context;

//User
- (User *)createUser:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (User *)getUserById:(NSUInteger)uid context:(NSManagedObjectContext *)context;

- (User *)getMainUserWithContext:(NSManagedObjectContext *)context;

- (User *)getMainUser;

//Comment
- (Comment *)createComment:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (Comment *)getCommentById:(NSUInteger)cid context:(NSManagedObjectContext *)context;

/** Networking **/

- (AFHTTPRequestOperation *)getDownloadList:(NSString *)cid
                                       page:(NSUInteger)page
                                    success:(void (^)(NSArray *array))success
                                    failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)getCommentsByNews:(News *)news
                                         page:(NSInteger)page
                                      success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)getConfigSuccess:(void (^)(void))success
                                     failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)userLogin:(NSDictionary *)param
                              success:(void (^)(User *user))success
                              failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)shareToSite:(NSInteger)postId
                                success:(void (^)(void))success
                                failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)dingToSite:(NSInteger)postId
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)collectToSite:(NSInteger)postId
                                   action:(NSString *)action
                                  success:(void (^)(void))success
                                  failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)postComment:(NSInteger)postId
                                comment:(NSString *)comment
                           replyComment:(Comment *)replyComment
                                success:(void (^)(void))success
                                failure:(void (^)(NSError *error))failure;

@end
