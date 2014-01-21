//
//  Category.h
//  BananaNews
//
//  Created by 龚涛 on 1/21/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewsCategory : NSManagedObject

@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * cname;
@property (nonatomic, retain) NSNumber * isHead;

@end
