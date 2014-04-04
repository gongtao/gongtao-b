//
//  BMRecommendViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMRecommendViewController.h"

#import "BMMovieItemView.h"

#import "BMSNSLoginView.h"

@interface BMRecommendViewController ()

@property (nonatomic, strong) BMCommonScrollorView *scView;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, assign) BOOL isReachable;

@property (nonatomic, assign) BOOL isLastPage;

@property (nonatomic, assign) BOOL isDownloading;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, strong) News *shareNews;

- (void)_updateData;

- (void)_loginToSite:(NSNotification *)notice;

- (void)_comment;

@end

@implementation BMRecommendViewController

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
    _isReachable = NO;
    _isLastPage = NO;
    _isDownloading = NO;
    _page = 1;
    
    self.view.backgroundColor = Color_ViewBg;
    
    CGFloat y = IS_IPhone5_or_5s?275.0:248.0;
    
    self.operateSubview = [[BMOperateSubView alloc] initWithFrame:CGRectMake(65.0, y, 190.0, 120.0)];
    self.operateSubview.delegate = self;
    [self.view addSubview:self.operateSubview];
    
    y = IS_IPhone5_or_5s?45.0:30.0;
    
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, y)];
    self.pageLabel.backgroundColor = [UIColor clearColor];
    self.pageLabel.textColor = Color_NavBarBg;
    self.pageLabel.font = [UIFont systemFontOfSize:17.0];
    self.pageLabel.text = @"1/3";
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pageLabel];
    
    _scView = [[BMCommonScrollorView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, 220.0)];
    _scView.delegate = self;
    _scView.dataSource = self;
    [self.view addSubview:_scView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginToSite:) name:kLoginSuccessNotification object:nil];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        NSLog(@"haha");
        [_scView updateNetworking:status];
        BOOL isReachable = status>AFNetworkReachabilityStatusNotReachable;
        if (isReachable && !_isReachable) {
            _isReachable = isReachable;
            BMNewsManager *manager = [BMNewsManager sharedManager];
            [manager configInit:^(void){
                [manager getConfigSuccess:^(void){
                    [self _updateData];
                }
                                  failure:nil];
            }];
        }
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataBase method

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:@"recommend"];
    _fetchedResultsController.delegate = self;
    
    [self performFetch];
    
    return _fetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    id appDelegate = [UIApplication sharedApplication].delegate;
    return [appDelegate managedObjectContext];
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"(ANY category.isHead == %@) AND (%K == %@)", [NSNumber numberWithBool:YES], kStatus, [NSNumber numberWithInt:0]];
    [request setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO], [NSSortDescriptor sortDescriptorWithKey:kStatus ascending:NO], nil]];
    return request;
}

- (void)performFetch
{
    if (!_fetchedResultsController) {
        [self fetchedResultsController];
        return;
    }
    
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Private

- (void)_updateData
{
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (count == 0) {
        if (_isLastPage) {
            NSLog(@"最后一页了");
            return;
        }
        if (_isDownloading) {
            return;
        }
        _isDownloading = YES;
        BMNewsManager *manager = [BMNewsManager sharedManager];
        NewsCategory *category = [manager getRecommendNewsCategory:[self managedObjectContext]];
        if (category) {
            [manager getRecommendList:category.category_id
                                 page:_page
                              success:^(BOOL isLast, int newPage){
                                  _isDownloading = NO;
                                  _isLastPage = isLast;
                                  self.page = newPage;
                                  
                                  if (_isLastPage) {
                                      NSLog(@"最后一页了");
                                  }
                                  [_scView updateSubViewData:self.fetchedResultsController];
                              }
                              failure:^(NSError *error){
                                  _isDownloading = NO;
                              }];
        }
    }
}

- (void)_loginToSite:(NSNotification *)notice
{
    User *user = notice.userInfo[@"user"];
    if (user) {
        [self _comment];
    }
}

- (void)_comment
{
    BMMovieItemView *item = [_scView currentSelectedView];
    if (item.news) {
        BMCommentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"commentViewController"];
        vc.news = item.news;
        vc.delegate = self;
        [self.parentViewController presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark -

- (void)videoDelete
{
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (_isLastPage && count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"视频" message:@"亲~没有可以加载的视频了哦~" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    BMMovieItemView *item = [_scView currentSelectedView];
    if (item.news) {
        [item deleteNews];
        if (count == 0) {
            [self _updateData];
        }
        else {
            News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            news.status = [NSNumber numberWithInteger:item.tag];
            [[BMNewsManager sharedManager] saveContext];
        }
    }
    else {
        [self _updateData];
    }
}

- (void)videoShare
{
    BMMovieItemView *item = [_scView currentSelectedView];
    if (item.news) {
        _shareNews = item.news;
        [[BMNewsManager sharedManager] shareNews:item.news delegate:self];
    }
}

- (void)videoGood
{
    BMMovieItemView *item = [_scView currentSelectedView];
    if (item.news) {
        [[BMNewsManager sharedManager] dingToSite:item.news.nid.integerValue success:nil failure:nil];
    }
}

- (void)videoBad
{
    [self _comment];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey]) {
//        [self _comment];
//    }
//    else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论" message:@"亲~请先登录再评论" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"登录", nil];
//        [alertView show];
//    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"登录"]) {
        BMSNSLoginView *loginView = [[BMSNSLoginView alloc] initWithFrame:self.parentViewController.view.bounds];
        [loginView showInView:self.parentViewController.view];
    }
}

#pragma mark - UMSocialUIDelegate

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if ((response.responseCode == UMSResponseCodeSuccess) &&
        _shareNews) {
        [[BMNewsManager sharedManager] shareToSite:_shareNews.nid.integerValue success:nil failure:nil];
    }
}

#pragma mark - BMCommonScrollorViewDataSource

- (BMMovieItemView *)pageAtIndex:(NSInteger)index withFrame:(CGRect)frame;
{
    return [[BMMovieItemView alloc] initWithFrame:frame tag:index+1 delegate:self];
}

#pragma mark - BMCommonScrollorViewDataSource

- (void)commonScrollorViewDidSelectPage:(NSUInteger)index
{
    self.pageLabel.text = [NSString stringWithFormat:@"%i/3", index+1];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self _updateData];
}

#pragma mark - BMMovieItemViewDelegate

- (void)didUpdateDataMovieItemView:(BMMovieItemView *)itemView
{
    
}

#pragma mark - BMCommentViewControllerDelegate

- (void)didCancelCommentViewController
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
