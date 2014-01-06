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

#define News_Entity             @"News"
#define kNid                    @"nid"

#define NewsCategory_Entity     @"NewsCategory"
#define kCategoryId             @"category_id"
#define kCid                    @"cid"

@interface BMNewsManager : NSObject

+ (BMNewsManager *)sharedManager;

- (NSManagedObjectContext *)managedObjectContext;

- (BOOL)saveContext:(NSManagedObjectContext *)context;

//Interface

- (void)createConfigFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (void)createNewsFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

//Database

- (News *)createNews:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (News *)getNewsById:(NSUInteger)nid context:(NSManagedObjectContext *)context;

- (NSArray *)getAllNews:(NSManagedObjectContext *)context;

- (NewsCategory *)createNewsCategory:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (NewsCategory *)getNewsCategoryById:(NSString *)cid context:(NSManagedObjectContext *)context;

- (NSArray *)getAllNewsCategory:(NSManagedObjectContext *)context;

//Networking

- (AFHTTPRequestOperation *)getDownloadList:(NSUInteger)type
                                       page:(NSUInteger)page
                                    success:(void (^)(NSArray *array))success
                                    failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)getConfigSuccess:(void (^)(void))success
                                     failure:(void (^)(NSError *error))failure;

@end
