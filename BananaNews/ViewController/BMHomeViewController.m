//
//  BMHomeViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMHomeViewController.h"

#import "BMPageViewController.h"

#import "IIViewDeckController.h"

#import "BMNewsManager.h"

@interface BMHomeViewController ()

@property (nonatomic, strong) BMPageViewController *pageVC;

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
    
    CGRect frame = self.view.bounds;
    frame.origin.y = CGRectGetMaxY(self.customNavigationBar.frame);
    frame.size.height -= frame.origin.y;
    
    _pageVC = [[BMPageViewController alloc] init];
    _pageVC.view.frame = frame;
    _pageVC.pageView.frame = CGRectMake(0.0, 32.0, 320.0, frame.size.height-32.0);
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_pageVC viewDidAppear:animated];
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
