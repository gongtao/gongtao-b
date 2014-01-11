//
//  BMCategoryViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/6/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMCategoryViewController.h"

#import "BMPageViewController.h"

@interface BMCategoryViewController ()

@property (nonatomic, strong) BMPageViewController *pageVC;

@end

@implementation BMCategoryViewController

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
    CGRect frame = self.view.bounds;
    frame.origin.y = CGRectGetMaxY(self.customNavigationBar.frame);
    frame.size.height -= frame.origin.y;
    
    _pageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
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

@end
