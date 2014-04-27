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
    
    UIView *searchTextBgView = [[UIView alloc] initWithFrame:CGRectMake(15.0, CGRectGetHeight(self.customNavigationBar.frame)-35.0, 240.0, 26.0)];
    searchTextBgView.backgroundColor = [UIColor whiteColor];
    searchTextBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    searchTextBgView.layer.cornerRadius = 3.0;
    [self.customNavigationBar addSubview:searchTextBgView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 2.0, CGRectGetWidth(searchTextBgView.frame)-25.0, 24.0)];
    textField.delegate = self;
    textField.placeholder = @"请输入查找内容";
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:12.0];
    textField.returnKeyType = UIReturnKeySearch;
    [searchTextBgView addSubview:textField];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(255.0, CGRectGetHeight(self.customNavigationBar.frame)-44.0, 65.0, 44.0)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:button];
    
    _searchVC = [[BMSubSearchListViewController alloc] initWithNibName:nil bundle:nil];
    _searchVC.view.frame = CGRectMake(0.0, y, 320.0, self.view.frame.size.height-y);
    _searchVC.tableView.frame = _searchVC.view.bounds;
    [self addChildViewController:_searchVC];
    [self.view addSubview:_searchVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_cancelButtonPressed:(UIButton *)button
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchVC searchNews:textField.text];
    return YES;
}

@end
