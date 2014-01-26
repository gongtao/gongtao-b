//
//  BMSearchViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-2.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSearchViewController.h"

#import "BMSearchView.h"

@interface BMSearchViewController ()

@property (nonatomic, strong) BMSearchView *searchView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

- (void)_searchButtonPressed:(id)sender;

@end

@implementation BMSearchViewController

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
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80.0, y+150.0, 50.0, 40.0)];
    _imageView.image = [UIImage imageNamed:@"搜索没有结果.png"];
    [self.view addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+2.0, CGRectGetMidY(_imageView.frame)-8.0, 80.0, 16.0)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"没有搜索结果~";
    _label.font = [UIFont systemFontOfSize:12.0];
    _label.textColor = Color_GrayFont;
    [self.view addSubview:_label];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, y, 320.0, self.view.frame.size.height-y)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_searchButtonPressed:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath row]) {
        [_searchView becomeFirstResponder];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (count < 2) {
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    else {
        self.tableView.backgroundColor = Color_ContentBg;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath row]) {
        return 55.0;
    }
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    UITableViewCell *cell = nil;
    if (0 == row) {
        static NSString *searchIdentifier = @"searchCell";
        cell = [tableView dequeueReusableCellWithIdentifier:searchIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            if (_searchView) {
                [_searchView removeFromSuperview];
            }
            else {
                _searchView = [[BMSearchView alloc] initWithFrame:CGRectMake(6.0, 9.0, 308.0, 40.0)];
                _searchView.textField.delegate = self;
                [_searchView.searchButton addTarget:self action:@selector(_searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell.contentView addSubview:_searchView];
        }
    }
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self _searchButtonPressed:nil];
    return YES;
}

@end
