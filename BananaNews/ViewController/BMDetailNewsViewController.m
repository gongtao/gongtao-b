//
//  BMDetailNewsViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/31/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMDetailNewsViewController.h"

#import "BMDetailViewController.h"

@interface BMDetailNewsViewController ()

@end

@implementation BMDetailNewsViewController

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
    CGFloat y = self.customNavigationBar.frame.size.height;
    BMDetailViewController *vc = [[BMDetailViewController alloc] initWithRequest:self.news];
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
