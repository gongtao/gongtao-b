//
//  Media.h
//  BananaNews
//
//  Created by 龚涛 on 1/17/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class News;

@interface Media : NSManagedObject

@property (nonatomic, retain) NSString * large;
@property (nonatomic, retain) NSNumber * large_height;
@property (nonatomic, retain) NSNumber * large_width;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSString * small;
@property (nonatomic, retain) NSNumber * small_height;
@property (nonatomic, retain) NSNumber * small_width;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *news;
@end

@interface Media (CoreDataGeneratedAccessors)

- (void)addNewsObject:(News *)value;
- (void)removeNewsObject:(News *)value;
- (void)addNews:(NSSet *)values;
- (void)removeNews:(NSSet *)values;

@end
