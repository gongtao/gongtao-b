//
//  BMUsersViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMUsersViewController.h"

#import "BMUserInfoViewController.h"

#import "BMUserButton.h"

@interface BMUsersViewController ()

- (void)_userButtonPressed:(BMUserButton *)button;

@end

@implementation BMUsersViewController

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
    self.title = @"相关用户";
    
    __block CGFloat y = CGRectGetMaxY(self.customNavigationBar.frame)+6.0;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, y, 320.0, self.view.frame.size.height-y)];
    [self.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.borderWidth = 1.0;
    contentView.layer.borderColor = Color_GrayLine.CGColor;
    contentView.layer.cornerRadius = 2.0;
    [scrollView addSubview:contentView];
    
    __block CGFloat x = 9.0;
    y = -69.0;
    [_users enumerateObjectsUsingBlock:^(User *user, NSUInteger idx, BOOL *stop){
        if (idx%5 == 0) {
            x = 9.0;
            y += 77.0;
        }
        BMUserButton *button = [[BMUserButton alloc] initWithFrame:CGRectMake(x, y, 58.0, 70.0)];
        button.user = user;
        [button addTarget:self action:@selector(_userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        x += 58.0;
    }];
    
    y += 98.0;
    contentView.frame = CGRectMake(6.0, 6.0, 308.0, y);
    scrollView.contentSize = CGSizeMake(320.0, y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_userButtonPressed:(BMUserButton *)button
{
    BMUserInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfoViewController"];
    vc.user = button.user;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
