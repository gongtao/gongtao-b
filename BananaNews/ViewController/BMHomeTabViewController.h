//
//  BMHomeTabViewController.h
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMToolBar.h"

@interface BMHomeTabViewController : UIViewController <BMToolBarDelegate>

@property (nonatomic, strong) UIView *customNavigationBar;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) NSMutableDictionary *subVCDic;

@property (nonatomic, assign) NSUInteger index;

@end
