//
//  BMSubSearchViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-4-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSubSearchViewController.h"

@interface BMSubSearchViewController ()

- (void)_cancelButtonPressed:(UIButton *)button;

@end

@implementation BMSubSearchViewController

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
    
    CGFloat y = CGRectGetMaxY(self.customNavigationBar.frame);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(42.0, y+150.0, 236.0, 45.0)];
    imageView.image = [UIImage imageNamed:@"搜索没找到.png"];
    [self.view addSubview:imageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(255.0, CGRectGetHeight(self.customNavigationBar.frame)-44.0, 65.0, 44.0)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private

- (void)_cancelButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
