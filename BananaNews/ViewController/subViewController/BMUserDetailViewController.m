//
//  BMUserDetailViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMUserDetailViewController.h"

@interface BMUserDetailViewController ()

@property (nonatomic, strong) UITableViewCell *firstCell;

@property (nonatomic, strong) UITableViewCell *secondCell;

- (void)_initFirstCell;

- (void)_initSecondCell;

@end

@implementation BMUserDetailViewController

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
    [[BMNewsManager sharedManager] getUserInfoById:self.user.uid.integerValue success:nil failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_initFirstCell
{
    if (!_firstCell) {
        _firstCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
}

- (void)_initSecondCell
{
    if (!_secondCell) {
        _secondCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

#pragma mark - Override

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    int row = [indexPath row];
    if (0 == row) {
        [self _initFirstCell];
        return _firstCell;
    }
    else if (1 == row) {
        [self _initSecondCell];
        return _secondCell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row-2 inSection:[indexPath section]] fetchedResultsController:fetchedResultsController];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:[newIndexPath row]+2 inSection:[newIndexPath section]];
    
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath1 forChangeType:type newIndexPath:indexPath2];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (0 == row || 1 == row) {
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row-2 inSection:[indexPath section]]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects]+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (0 == row) {
        return 94.0;
    }
    else if (1 == row) {
        return 20.0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row-2 inSection:[indexPath section]]];
}

@end
