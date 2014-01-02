//
//  BMLeftViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMLeftViewController.h"

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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, y, 320.0, 365.0)];
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = Color_SideBg;
    [self.view addSubview:_tableView];
    
    _searchView = [[BMSearchView alloc] initWithFrame:CGRectMake(8.0, 323.0, 216.0, 40.0)];
    _searchView.textField.delegate = self;
    [_searchView.searchButton addTarget:self action:@selector(_searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:_searchView];
    
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

#pragma mark - Private

- (void)_searchButtonPressed:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
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
        
        BMLeftViewCell *cell = (BMLeftViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastSelectedRow inSection:0]];
        if (cell) {
            cell.isCurrent = NO;
        }
        cell = (BMLeftViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            cell.isCurrent = YES;
        }
        
        _lastSelectedRow = row;
        [self.viewDeckController setCenterController:vc];
    }
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self _searchButtonPressed:nil];
    return YES;
}

@end
