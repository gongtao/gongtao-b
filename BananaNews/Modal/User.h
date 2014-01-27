//
//  User.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-26.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, News;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSNumber * isMainUser;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *news;
@property (nonatomic, retain) NSOrderedSet *collectNews;
@property (nonatomic, retain) NSSet *replyComment;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addNewsObject:(News *)value;
- (void)removeNewsObject:(News *)value;
- (void)addNews:(NSSet *)values;
- (void)removeNews:(NSSet *)values;

- (void)insertObject:(News *)value inCollectNewsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCollectNewsAtIndex:(NSUInteger)idx;
- (void)insertCollectNews:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCollectNewsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCollectNewsAtIndex:(NSUInteger)idx withObject:(News *)value;
- (void)replaceCollectNewsAtIndexes:(NSIndexSet *)indexes withCollectNews:(NSArray *)values;
- (void)addCollectNewsObject:(News *)value;
- (void)removeCollectNewsObject:(News *)value;
- (void)addCollectNews:(NSOrderedSet *)values;
- (void)removeCollectNews:(NSOrderedSet *)values;
- (void)addReplyCommentObject:(Comment *)value;
- (void)removeReplyCommentObject:(Comment *)value;
- (void)addReplyComment:(NSSet *)values;
- (void)removeReplyComment:(NSSet *)values;

@end
