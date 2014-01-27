//
//  Comment.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-26.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class News, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * ding;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) News *news;
@property (nonatomic, retain) User *replyUser;

@end
