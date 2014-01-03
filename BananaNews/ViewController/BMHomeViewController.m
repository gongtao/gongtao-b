//
//  BMHomeViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMHomeViewController.h"

#import "BMListViewController.h"

#import "IIViewDeckController.h"

#import "BMNewsManager.h"

@interface BMHomeViewController ()

- (void)_leftButtonPressed:(id)sender;

- (void)_rightButtonPressed:(id)sender;

@end

@implementation BMHomeViewController

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
    self.customNavigationBar.centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页LOGO.png"]];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [leftButton setImage:[UIImage imageNamed:@"左侧导航按钮.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"左侧导航按钮.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(_leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.customNavigationBar.leftView = leftButton;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [rightButton setImage:[UIImage imageNamed:@"右侧用户按钮.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"右侧用户按钮.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(_rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.customNavigationBar.rightView = rightButton;
    
    [[BMNewsManager sharedManager] getDownloadList:0 page:0 success:nil failure:nil];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = CGRectGetMaxY(self.customNavigationBar.frame);
    frame.size.height -= frame.origin.y;
    
    BMListViewController *listVC = [[BMListViewController alloc] init];
    listVC.view.frame = frame;
    listVC.tableView.frame = listVC.view.bounds;
    [self addChildViewController:listVC];
    [self.view addSubview:listVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_leftButtonPressed:(id)sender
{
    [self.viewDeckController openLeftViewAnimated:YES];
}

- (void)_rightButtonPressed:(id)sender
{
    [self.viewDeckController openRightViewAnimated:YES];
}

@end
