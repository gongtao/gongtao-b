//
//  BMListViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMListViewController.h"

#import "BMDetailNewsViewController.h"

@interface BMListViewController ()
{
    NSString *_cache;
}

@property (nonatomic, strong) NSFetchRequest *fetchRequest;

- (void)reloadTableViewDataSource;

- (void)doneLoadingTableViewData;

- (void)_dingButtonPressed:(UIButton *)sender;

- (void)_shareButtonPressed:(UIButton *)sender;

- (void)_collectButtonPressed:(UIButton *)sender;

@end

@implementation BMListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRequest:(NSFetchRequest *)request cacheName:(NSString *)cache
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _fetchRequest = request;
        _fetchRequest.fetchBatchSize = 10;
        _cache = cache;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.rowAnimation = UITableViewRowAnimationNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _type = BMNewsListCellNormal;
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_dingButtonPressed:(UIButton *)sender
{
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [[BMNewsManager sharedManager] dingToSite:news.nid.integerValue success:nil failure:nil];
}

- (void)_shareButtonPressed:(UIButton *)sender
{
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    _postId = sender.tag;
    [[BMNewsManager sharedManager] shareNews:news delegate:self];
}

- (void)_collectButtonPressed:(UIButton *)sender
{
    
}

#pragma mark - Override

- (NSFetchRequest *)fetchRequest
{
    if (_fetchRequest) {
        return _fetchRequest;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    return request;
}

- (NSString *)cacheName
{
    return _cache;
}

- (void)configCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    NSInteger row = [indexPath row];
    News *news = [fetchedResultsController objectAtIndexPath:indexPath];
    BMNewsListCell *newCell = (BMNewsListCell *)cell;
    [newCell configCellNews:news];
    
    newCell.dingButton.tag = row;
    newCell.shareButton.tag = row;
    if (BMNewsListCellCollect == newCell.type) {
        newCell.collectButton.tag = row;
        [newCell.collectButton addTarget:self action:@selector(_collectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    static NSString *CellIdentifier = @"ListCell";
    BMNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BMNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.type = self.type;
        [cell.dingButton addTarget:self action:@selector(_dingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareButton addTarget:self action:@selector(_shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self configCell:cell cellForRowAtIndexPath:indexPath fetchedResultsController:fetchedResultsController];
    
    return cell;
}

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    _reloading = YES;
    [[BMNewsManager sharedManager] getDownloadList:self.category.category_id
                                              page:0
                                           success:^(NSArray *array){
                                               [self doneLoadingTableViewData];
                                           }
                                           failure:^(NSError *error){
                                               [self doneLoadingTableViewData];
                                           }];
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.tableView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        [_refreshHeaderView egoRefreshScrollViewWillBeginDragging:scrollView];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMDetailNewsViewController *vc = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"detailNewsViewController"];
    vc.news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (!news.medias || news.medias.count == 0) {
        return news.text_height.floatValue+52.0;
    }
    return news.text_height.floatValue+news.image_height.floatValue+64.0;
}

#pragma mark EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return self.category.refreshTime; // should return date data source was last changed
}

#pragma mark - UMSocialUIDelegate

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:_postId inSection:0]];
    [[BMNewsManager sharedManager] shareToSite:news.nid.integerValue success:nil failure:nil];
}

@end
