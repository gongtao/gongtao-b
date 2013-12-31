//
//  BMBaseViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/31/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMBaseViewController.h"

@interface BMBaseViewController ()

@end

@implementation BMBaseViewController

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
    
    self.customNavigationBar = [[BMNavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, IS_IOS7?64.0:44.0)];
    self.customNavigationBar.backgroundColor = Color_Yellow;
    [self.view addSubview:self.customNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
