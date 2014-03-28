//
//  News.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-29.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewsCategory, Comment, Media, User;

@interface News : NSManagedObject

@property (nonatomic, retain) NSNumber * comment_count;
@property (nonatomic, retain) NSNumber * fa_count;
@property (nonatomic, retain) NSNumber * image_height;
@property (nonatomic, retain) NSNumber * like_count;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * ndate;
@property (nonatomic, retain) NSNumber * nid;
@property (nonatomic, retain) NSNumber * share_count;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * text_height;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * isSearch;
@property (nonatomic, retain) NSOrderedSet *category;
@property (nonatomic, retain) NSSet *collectUsers;
@property (nonatomic, retain) NSOrderedSet *comments;
@property (nonatomic, retain) NSOrderedSet *medias;
@property (nonatomic, retain) User *user;
@end

@interface News (CoreDataGeneratedAccessors)

- (void)insertObject:(NewsCategory *)value inCategoryAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCategoryAtIndex:(NSUInteger)idx;
- (void)insertCategory:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCategoryAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCategoryAtIndex:(NSUInteger)idx withObject:(NewsCategory *)value;
- (void)replaceCategoryAtIndexes:(NSIndexSet *)indexes withCategory:(NSArray *)values;
- (void)addCategoryObject:(NewsCategory *)value;
- (void)removeCategoryObject:(NewsCategory *)value;
- (void)addCategory:(NSOrderedSet *)values;
- (void)removeCategory:(NSOrderedSet *)values;
- (void)addCollectUsersObject:(User *)value;
- (void)removeCollectUsersObject:(User *)value;
- (void)addCollectUsers:(NSSet *)values;
- (void)removeCollectUsers:(NSSet *)values;

- (void)insertObject:(Comment *)value inCommentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentsAtIndex:(NSUInteger)idx;
- (void)insertComments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentsAtIndex:(NSUInteger)idx withObject:(Comment *)value;
- (void)replaceCommentsAtIndexes:(NSIndexSet *)indexes withComments:(NSArray *)values;
- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSOrderedSet *)values;
- (void)removeComments:(NSOrderedSet *)values;
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
