//
//  News.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-7.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author, Media;

@interface News : NSManagedObject

@property (nonatomic, retain) NSNumber * comment_count;
@property (nonatomic, retain) NSDate * ndate;
@property (nonatomic, retain) NSNumber * nid;
@property (nonatomic, retain) NSNumber * text_height;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * image_height;
@property (nonatomic, retain) Author *author;
@property (nonatomic, retain) NSOrderedSet *medias;
@end

@interface News (CoreDataGeneratedAccessors)

- (void)insertObject:(Media *)value inMediasAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMediasAtIndex:(NSUInteger)idx;
- (void)insertMedias:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMediasAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMediasAtIndex:(NSUInteger)idx withObject:(Media *)value;
- (void)replaceMediasAtIndexes:(NSIndexSet *)indexes withMedias:(NSArray *)values;
- (void)addMediasObject:(Media *)value;
- (void)removeMediasObject:(Media *)value;
- (void)addMedias:(NSOrderedSet *)values;
- (void)removeMedias:(NSOrderedSet *)values;
@end
