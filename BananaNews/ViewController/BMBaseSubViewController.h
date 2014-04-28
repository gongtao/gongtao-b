//
//  BMBaseSubViewController.h
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMCustomButton.h"

@interface BMBaseSubViewController : UIViewController

@property (nonatomic, strong) UIView *customNavigationBar;

@property (nonatomic, strong) UILabel *customNavigationTitle;

@property (nonatomic, strong) BMCustomButton *customNavigationReturn;

@end
