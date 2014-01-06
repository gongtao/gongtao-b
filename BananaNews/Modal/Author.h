//
//  Author.h
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class News;

@interface Author : NSManagedObject

@property (nonatomic, retain) NSNumber * aid;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *news;
@end

@interface Author (CoreDataGeneratedAccessors)

- (void)addNewsObject:(News *)value;
- (void)removeNewsObject:(News *)value;
- (void)addNews:(NSSet *)values;
- (void)removeNews:(NSSet *)values;

@end