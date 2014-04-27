//
//  BMSubCategoryDetailViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-4-22.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSubCategoryDetailViewController.h"

@interface BMSubCategoryDetailViewController ()

@property (nonatomic, strong) BMOperateSubView *operateSubview;

@property (nonatomic, strong) UILabel *pageLabel;

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
    
    self.view.backgroundColor = Color_ViewBg;
    
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.customNavigationBar.frame), 320.0, 45.0)];
    self.pageLabel.backgroundColor = [UIColor clearColor];
    self.pageLabel.textColor = Color_NavBarBg;
    self.pageLabel.font = [UIFont systemFontOfSize:17.0];
    self.pageLabel.text = @"0/3";
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pageLabel];
    
    self.operateSubview = [[BMOperateSubView alloc] initWithFrame:CGRectMake(65.0, 295.0, 190.0, 120.0)];
    self.operateSubview.delegate = self;
    self.operateSubview.buttonDelete.hidden = YES;
    [self.view addSubview:self.operateSubview];
    
    self.customNavigationTitle.text = _category.cname;
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

#pragma mark - BMOperateSubViewDelegate

-(void)videoShare
{
    
}

-(void)videoGood
{
    
}

-(void)videoBad
{
    
}

@end
