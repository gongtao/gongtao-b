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
    
    self.tableView.frame = CGRectMake(0.0, y+44.5, 320.0, self.view.frame.size.height-y-44.5);
    self.tableView.bounces = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = Color_SideBg;
    self.tableView.scrollsToTop = NO;
    
    self.controllerDic = [[NSMutableDictionary alloc] init];
    
    self.controllerDic[@"0"] = self.viewDeckController.centerController;
    
    _lastSelectedRow = 0;
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSString *index = [NSString stringWithFormat:@"%li", (long)_lastSelectedRow];
    UIViewController *vc = self.controllerDic[index];
    [self.controllerDic removeAllObjects];
    self.controllerDic[index] = vc;
}

#pragma mark - Public

- (void)selectVCAtIndex:(NSUInteger)row
{
    if (_lastSelectedRow == row) {
        _lastSelectedRow = row;
    }
    else {
        NSString *index = [NSString stringWithFormat:@"%lu", (unsigned long)row];
        UIViewController *vc = self.controllerDic[index];
        if (!vc) {
            if (row == [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]+1) {
                vc = [self.storyboard instantiateViewControllerWithIdentifier:@"submissionViewController"];
            }
            else if (row == 0) {
                vc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
            }
            else {
                NewsCategory *newsCategory = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0]];
                vc = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryViewController"];
                vc.title = newsCategory.cname;
            }
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
    [self deselectVC];
    BMSearchViewController *vc = (BMSearchViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    self.viewDeckController.centerController = vc;
    [self.viewDeckController closeLeftViewAnimated:YES];
}

#pragma mark - Override

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NewsCategory_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", kIsHead, [NSNumber numberWithBool:NO]];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kCid ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    return request;
}

- (NSString *)cacheName
{
    return @"LeftCache";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    static NSString *CellIdentifier = @"BMLeftCell";
    BMLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BMLeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    if (row == [[[self.fetchedResultsController sections] objectAtIndex:[indexPath section]] numberOfObjects]+1) {
        cell.textLabel.text = @"投稿";
    }
    else if (row == 0) {
        cell.textLabel.text = @"首页";
    }
    else {
        NewsCategory *newsCategory = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0]];
        cell.textLabel.text = newsCategory.cname;
    }
    cell.isCurrent = (_lastSelectedRow == row);
    
    return cell;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:[newIndexPath row]+1 inSection:[newIndexPath section]];
    
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath1 forChangeType:type newIndexPath:indexPath2];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectVCAtIndex:[indexPath row]];
    [self.viewDeckController closeLeftViewAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects]+1;
}

@end
