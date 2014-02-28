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
    
    UIView *_footerLoadingView;
    
    UIButton *_footerButton;
    
    UIActivityIndicatorView *_activityView;
    
    AFHTTPRequestOperation *_request;
    
    UITableViewCell *_footerView;
    
    NSInteger _page;
}

@property (nonatomic, strong) NSFetchRequest *fetchRequest;

- (void)reloadTableViewDataSource;

- (void)_dingButtonPressed:(UIButton *)sender;

- (void)_shareButtonPressed:(UIButton *)sender;

- (void)_collectButtonPressed:(UIButton *)sender;

- (void)_finishLoadMore:(BOOL)isFinished;

- (void)_loadMore:(UIButton *)sender;

- (void)_initFooterView;

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
    
    [self _initFooterView];
    
    [NSFetchedResultsController deleteCacheWithName:[self cacheName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [NSFetchedResultsController deleteCacheWithName:[self cacheName]];
}

#pragma mark - Public

- (void)refreshLastUpdateTime
{
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)startLoadingTableViewData
{
    if (_reloading) {
        [self doneLoadingTableViewData];
    }
    NSInteger count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (0 == count) {
        _page = 1;
        [_refreshHeaderView egoRefreshScrollViewWillBeginDragging:self.tableView];
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0.0, -65.0);
                         }
                         completion:^(BOOL finished){
                             [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
                         }];
    }
    else {
        _page = count/10+((count%10!=0)?2:1);
    }
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

- (void)_finishLoadMore:(BOOL)isFinished
{
    if (isFinished) {
        [_activityView stopAnimating];
    }
    else {
        [_activityView startAnimating];
    }
    [_footerLoadingView setHidden:isFinished];
    [_footerButton setHidden:!isFinished];
}

- (void)_loadMore:(UIButton *)sender
{
    [self _finishLoadMore:NO];
    _request = [[BMNewsManager sharedManager] getDownloadList:self.categoryId
                                                         page:_page
                                                      success:^(NSArray *array){
                                                          [self _finishLoadMore:YES];
                                                      }
                                                      failure:^(NSError *error){
                                                          [self _finishLoadMore:YES];
                                                      }];
}

- (void)_initFooterView
{
    if (!_footerView) {
        _footerView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _footerView.backgroundColor = [UIColor clearColor];
        _footerView.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
        _footerButton.titleLabel.font = Font_NewsTitle;
        [_footerButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
        [_footerButton setTitleColor:Color_NewsSmallFont forState:UIControlStateNormal];
        [_footerButton addTarget:self action:@selector(_loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_footerButton];
        
        _footerLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
        _footerLoadingView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:_footerLoadingView];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = Font_NewsTitle;
        label.textColor = Color_NewsSmallFont;
        label.text = @"正在加载更多。。。";
        [label sizeToFit];
        label.center = CGPointMake(160.0, 25.0);
        [_footerLoadingView addSubview:label];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.center = CGPointMake(70.0, 25.0);
        [_footerLoadingView addSubview:_activityView];
        
        [self _finishLoadMore:YES];
    }
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
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if ([indexPath row] == count) {
        [self _initFooterView];
        return _footerView;
    }
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
    if (_request) {
        [_request cancel];
        _request = nil;
    }
    [self _finishLoadMore:YES];
    _reloading = YES;
    _page = 1;
    [[BMNewsManager sharedManager] getDownloadList:self.categoryId
                                              page:_page
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
    [self refreshLastUpdateTime];
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
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if ([indexPath row] == count) {
        return;
    }
    BMDetailNewsViewController *vc = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"detailNewsViewController"];
    vc.news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (0 == count) {
        _page = 1;
    }
    else {
        _page = count/10+((count%10==0)?1:2);
    }
    return count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (row == count) {
        if (count < 10) {
            return 0.0;
        }
        else {
            return 50.0;
        }
    }
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

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    BMNewsManager *manager = [BMNewsManager sharedManager];
    NewsCategory *category = [manager getNewsCategoryById:self.categoryId context:[manager managedObjectContext]];
    return category.refreshTime;// should return date data source was last changed
}

#pragma mark - UMSocialUIDelegate

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:_postId inSection:0]];
        [[BMNewsManager sharedManager] shareToSite:news.nid.integerValue success:nil failure:nil];
    }
}

@end
