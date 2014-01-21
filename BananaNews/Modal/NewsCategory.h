//
//  Category.h
//  BananaNews
//
//  Created by 龚涛 on 1/21/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class News;

@interface NewsCategory : NSManagedObject

@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * cname;
@property (nonatomic, retain) NSNumber * isHead;
@property (nonatomic, retain) NSDate * refreshTime;
@property (nonatomic, retain) NSOrderedSet *list;
@end

@interface NewsCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(News *)value inListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromListAtIndex:(NSUInteger)idx;
- (void)insertList:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInListAtIndex:(NSUInteger)idx withObject:(News *)value;
- (void)replaceListAtIndexes:(NSIndexSet *)indexes withList:(NSArray *)values;
- (void)addListObject:(News *)value;
- (void)removeListObject:(News *)value;
- (void)addList:(NSOrderedSet *)values;
- (void)removeList:(NSOrderedSet *)values;
@end
