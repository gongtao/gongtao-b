//
//  BMLeftViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMLeftViewController.h"

#import "BMSearchViewController.h"

#import "BMLeftViewCell.h"

#import "IIViewDeckController.h"

@interface BMLeftViewController ()

- (void)_searchButtonPressed:(id)sender;

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
    self.view.backgroundColor = Color_SideBg;
    
    CGFloat y = IS_IOS7 ? 20.0 : 0.0;
    
    UIControl *searchView = [[UIControl alloc] initWithFrame:CGRectMake(8.0, y+4.0, 216.0, 36.0)];
    searchView.backgroundColor = Color_CellBg;
    searchView.layer.borderColor = Color_GrayLine.CGColor;
    searchView.layer.borderWidth = 1.0;
    [searchView addTarget:self action:@selector(_searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 0.0, searchView.frame.size.width-32.0, 36.0)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = @"搜索更多";
    label.textColor = Color_SideFont;
    label.backgroundColor = [UIColor clearColor];
    [searchView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(searchView.frame.size.width-25.0, (searchView.frame.size.height-25.0)/2, 25.0, 25.0)];
    imageView.image = [UIImage imageNamed:@"搜索.png"];
    [searchView addSubview:imageView];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, y+43.5, 320.0, 1.0)];
    separatorView.backgroundColor = Color_GrayLine;
    [self.view addSubview:separatorView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, y+44.5, 320.0, 308.0)];
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = Color_SideBg;
    _tableView.scrollsToTop = NO;
    [self.view addSubview:_tableView];
    
    self.titleArray = @[@"首      页", @"图      文", @"动      图", @"视      频",
                        @"音      频", @"短      文", @"投      稿"];
    
    self.controllerTitleArray = @[@"homeViewController", @"imageTextViewController",
                                  @"dynamicImageViewController", @"videoViewController",
                                  @"audioViewController", @"shorEssayViewController",
                                  @"submissionViewController"];
    
    self.controllerDic = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    self.controllerDic[@"0"] = self.viewDeckController.centerController;
    
    _lastSelectedRow = 0;
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSString *index = [NSString stringWithFormat:@"%i", _lastSelectedRow];
    [self.controllerDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if (![index isEqualToString:key]) {
            [self.controllerDic removeObjectForKey:key];
        }
    }];
}

#pragma mark - Public

- (void)selectVCAtIndex:(NSUInteger)row
{
    if (_lastSelectedRow == row) {
        _lastSelectedRow = row;
    }
    else {
        NSString *index = [NSString stringWithFormat:@"%i", row];
        UIViewController *vc = self.controllerDic[index];
        if (!vc) {
            vc = [self.storyboard instantiateViewControllerWithIdentifier:self.controllerTitleArray[row]];
            self.controllerDic[index] = vc;
        }
        
        BMLeftViewCell *cell = nil;
        if (-1 != _lastSelectedRow) {
            cell = (BMLeftViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastSelectedRow inSection:0]];
            if (cell) {
                cell.isCurrent = NO;
            }
        }
        cell = (BMLeftViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        if (cell) {
            cell.isCurrent = YES;
        }
        
        _lastSelectedRow = row;
        [self.viewDeckController setCenterController:vc];
    }
}

- (void)deselectVC
{
    BMLeftViewCell *cell = nil;
    if (-1 != _lastSelectedRow) {
        cell = (BMLeftViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastSelectedRow inSection:0]];
        if (cell) {
            cell.isCurrent = NO;
        }
    }
    _lastSelectedRow = -1;
}

#pragma mark - Private

- (void)_searchButtonPressed:(id)sender
{
    BMSearchViewController *vc = (BMSearchViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    self.viewDeckController.centerController = vc;
    [self.viewDeckController closeLeftViewAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectVCAtIndex:[indexPath row]];
    [self.viewDeckController closeLeftViewAnimated:YES];
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
    cell.isCurrent = (_lastSelectedRow == row);
    
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
