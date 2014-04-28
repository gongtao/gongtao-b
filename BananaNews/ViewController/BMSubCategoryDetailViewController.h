//
//  BMSubCategoryDetailViewController.h
//  BananaNews
//
//  Created by 龚 涛 on 14-4-22.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMBaseSubViewController.h"

#import "BMCommentViewController.h"

#import "BMOperateSubView.h"

#import "BMMoviePageView.h"

@interface BMSubCategoryDetailViewController : BMBaseSubViewController <BMOperateSubViewDelegate, BMMoviePageViewDelegate, BMCommentViewControllerDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) NewsCategory *category;

@end
