//
//  BMSubSettingsViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMSubSettingsViewController.h"

#import "BMSettingTableViewController.h"

@interface BMSubSettingsViewController ()

@end

@implementation BMSubSettingsViewController

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
    self.view.backgroundColor = Color_ViewBg;
    BMSettingTableViewController *tvc=[[BMSettingTableViewController alloc]initWithStyle:UITableViewStylePlain];
    tvc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    tvc.tableView.frame=CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:tvc];
    [self.view addSubview:tvc.view];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
