//
//  BMUserInfoViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-26.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMUserInfoViewController.h"

#import "BMUserDetailViewController.h"

@interface BMUserInfoViewController ()

@end

@implementation BMUserInfoViewController

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
    if (self.user.isMainUser.boolValue) {
        self.title = @"我的主页";
    }
    else {
        self.title = @"他的主页";
    }
    
    CGFloat y = self.customNavigationBar.frame.size.height;
    BMUserDetailViewController *vc = [[BMUserDetailViewController alloc] initWithNibName:nil bundle:nil];
    vc.user = self.user;
    vc.view.frame = CGRectMake(0.0, y, 320.0, self.view.frame.size.height-y);
    vc.tableView.frame = vc.view.bounds;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
