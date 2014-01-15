//
//  BMSettingViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-2.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSettingViewController.h"

#import "BMFeedbackViewController.h"

@interface BMSettingViewController ()

@end

@implementation BMSettingViewController

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
    BMFeedbackViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"feedbackViewController"];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
