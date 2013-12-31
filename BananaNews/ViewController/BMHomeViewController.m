//
//  BMHomeViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMHomeViewController.h"

#import "IIViewDeckController.h"

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
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页LOGO.png"]];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [leftButton setImage:[UIImage imageNamed:@"左侧导航按钮.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(_leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [rightButton setImage:[UIImage imageNamed:@"右侧用户按钮.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(_rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
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
