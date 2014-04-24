//
//  BMBaseSubViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMBaseSubViewController.h"

@interface BMBaseSubViewController ()

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
    _customNavigationTitle.backgroundColor = [UIColor clearColor];
    [self.customNavigationBar addSubview:_customNavigationTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
