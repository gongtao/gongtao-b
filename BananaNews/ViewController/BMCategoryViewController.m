//
//  BMCategoryViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/6/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMCategoryViewController.h"

#import "BMListViewController.h"

@interface BMCategoryViewController ()

@property (nonatomic, strong) BMListViewController *listVC;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
