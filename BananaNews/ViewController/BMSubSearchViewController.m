//
//  BMSubSearchViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-4-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSubSearchViewController.h"

#import "BMSubSearchListViewController.h"

@interface BMSubSearchViewController ()

@property (nonatomic, strong) BMSubSearchListViewController *searchVC;

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
    
    UIView *searchTextBgView = [[UIView alloc] initWithFrame:CGRectMake(15.0, CGRectGetHeight(self.customNavigationBar.frame)-35.0, 240.0, 26.0)];
    searchTextBgView.backgroundColor = [UIColor whiteColor];
    searchTextBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    searchTextBgView.layer.cornerRadius = 3.0;
    [self.customNavigationBar addSubview:searchTextBgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 6.0, 14.0, 14.0)];
    imageView.image = [UIImage imageNamed:@"搜索输入icon.png"];
    [searchTextBgView addSubview:imageView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 2.0, CGRectGetWidth(searchTextBgView.frame)-25.0, 24.0)];
    textField.delegate = self;
    textField.placeholder = @"请输入查找内容";
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:12.0];
    textField.returnKeyType = UIReturnKeySearch;
    [searchTextBgView addSubview:textField];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(255.0, CGRectGetHeight(self.customNavigationBar.frame)-44.0, 65.0, 44.0)];
    [_button setTitle:@"取消" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.customNavigationBar addSubview:_button];
    
    _searchVC = [[BMSubSearchListViewController alloc] initWithNibName:nil bundle:nil];
    _searchVC.view.frame = CGRectMake(0.0, y, 320.0, self.view.frame.size.height-y);
    _searchVC.tableView.frame = _searchVC.view.bounds;
    [self addChildViewController:_searchVC];
    [self.view addSubview:_searchVC.view];
    
    self.customNavigationReturn.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchVC searchNews:textField.text];
    return YES;
}

@end
