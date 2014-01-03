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

#define News_Entity         @"News"
#define kNid                @"nid"

@interface BMNewsManager : NSObject

+ (BMNewsManager *)sharedManager;

- (NSManagedObjectContext *)managedObjectContext;

- (BOOL)saveContext:(NSManagedObjectContext *)context;

//Interface

- (void)createNewsFromNetworking:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

//Database

- (News *)createNews:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

- (News *)getNewsById:(NSUInteger)nid context:(NSManagedObjectContext *)context;

- (NSArray *)getAllNews:(NSManagedObjectContext *)context;

//Networking

- (AFHTTPRequestOperation *)getDownloadList:(NSUInteger)type
                                       page:(NSUInteger)page
                                    success:(void (^)(NSArray *array))success
                                    failure:(void (^)(NSError *error))failure;

@end
