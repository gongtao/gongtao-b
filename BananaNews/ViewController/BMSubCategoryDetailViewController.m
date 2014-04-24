//
//  BMSubCategoryDetailViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-4-22.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSubCategoryDetailViewController.h"

@interface BMSubCategoryDetailViewController ()

@end

@implementation BMSubCategoryDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCategory:(NewsCategory *)category
{
    if (_category != category) {
        _category = category;
    }
}

@end
