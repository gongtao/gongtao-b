//
//  User.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-18.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, News;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * isMainUser;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *news;
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

@end
