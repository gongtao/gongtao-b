//
//  BMBaseSubViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMBaseSubViewController.h"

@interface BMBaseSubViewController ()

- (void)_backButtonPressed:(UIButton *)button;

@end

@implementation BMBaseSubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = Color_ViewBg;
    
    CGFloat y = IS_IOS7?64.0:44.0;
    
    self.customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, y)];
    self.customNavigationBar.backgroundColor = Color_NavBarBg;
    [self.view addSubview:self.customNavigationBar];
    
    _customNavigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, y-44.0, 320.0, 44.0)];
    _customNavigationTitle.font = [UIFont systemFontOfSize:17.0];
    _customNavigationTitle.textColor = [UIColor whiteColor];
    _customNavigationTitle.backgroundColor = [UIColor clearColor];
    _customNavigationTitle.textAlignment = NSTextAlignmentCenter;
    [self.customNavigationBar addSubview:_customNavigationTitle];
    
    _customNavigationReturn = [[BMCustomButton alloc] initWithFrame:CGRectMake(0.0, y-44.0, 44.0, 44.0)];
    _customNavigationReturn.imageRect = CGRectMake(0.0, 0.0, 44.0, 44.0);
    [_customNavigationReturn addTarget:self action:@selector(_backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_customNavigationReturn setImage:[UIImage imageNamed:@"导航返回.png"] forState:UIControlStateNormal];
    [_customNavigationReturn setImage:[UIImage imageNamed:@"导航返回.png"] forState:UIControlStateHighlighted];
    [self.customNavigationBar addSubview:_customNavigationReturn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_backButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
