//
//  BMSubCategoryDetailViewController.h
//  BananaNews
//
//  Created by 龚 涛 on 14-4-22.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMBaseSubViewController.h"

#import "BMOperateSubView.h"

@interface BMSubCategoryDetailViewController : BMBaseSubViewController <BMOperateSubViewDelegate>

@property (nonatomic, strong) NewsCategory *category;

@end
