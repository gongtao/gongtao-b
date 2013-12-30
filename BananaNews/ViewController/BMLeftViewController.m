//
//  BMLeftViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMLeftViewController.h"

#import "BMLeftViewCell.h"

@interface BMLeftViewController ()

@end

@implementation BMLeftViewController

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
    CGFloat y = IS_IOS7 ? 20.0 : 0.0;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, y, kSidePanelLeftWidth, 308.0)];
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    self.titleArray = @[@"首      页", @"图      文", @"动      图", @"视      频",
                        @"音      频", @"短      文", @"投      稿"];
    self.controllerArray = @[@"首页", @"图文", @"动图", @"视频", @"音频", @"短文", @"投稿"];
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BMLeftCell";
    BMLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BMLeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = self.titleArray[row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

@end
