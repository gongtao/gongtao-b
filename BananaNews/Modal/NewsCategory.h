//
//  Category.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-7.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewsCategory : NSManagedObject

@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) NSString * cname;

@end
