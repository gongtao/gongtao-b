//
//  BMSubSearchListViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-4-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSubSearchListViewController.h"

#import "BMHistoryTableViewCell.h"

#import <MediaPlayer/MediaPlayer.h>

@interface BMSubSearchListViewController ()
{
    BOOL _isSearch;
    
    UIActivityIndicatorView *_indicatorView;
    
    UIImageView *_imageView;
}

@end

@implementation BMSubSearchListViewController

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
    self.rowAnimation = UITableViewRowAnimationNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [NSFetchedResultsController deleteCacheWithName:[self cacheName]];
    _isSearch = NO;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(42.0, 150.0, 236.0, 45.0)];
    _imageView.image = [UIImage imageNamed:@"搜索没找到.png"];
    [self.view insertSubview:_imageView belowSubview:self.tableView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    _indicatorView.hidden = YES;
    [self.view addSubview:_indicatorView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[BMNewsManager sharedManager] clearSearchData:nil];
}

- (void)searchNews:(NSString *)key
{
    [self.view.superview endEditing:YES];
    if (!key || key.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"搜索" message:@"请输入搜索关键字" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    _isSearch = YES;
    [_indicatorView startAnimating];
    _indicatorView.hidden = NO;
    _imageView.hidden = YES;
    __block BMNewsManager *manager = [BMNewsManager sharedManager];
    [manager clearSearchData:^(void){
        [manager getSearchNews:key
                       success:^(void){
                           _isSearch = NO;
                           [_indicatorView stopAnimating];
                           _indicatorView.hidden = YES;
                           _imageView.hidden = NO;
                       }
                       failure:^(NSError *error){
                           _isSearch = NO;
                           [_indicatorView stopAnimating];
                           _indicatorView.hidden = YES;
                           _imageView.hidden = NO;
                       }];
    }];
}

#pragma mark - Override

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", kIsNewsSearch, [NSNumber numberWithBool:YES]]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    return request;
}

- (NSString *)cacheName
{
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (news) {
        __block Media *media = nil;
        [news.medias enumerateObjectsUsingBlock:^(Media *obj, NSUInteger idx, BOOL *stop){
            if ([obj.type rangeOfString:@"image"].location == NSNotFound) {
                media = obj;
                *stop = YES;
            }
        }];
        if (!media) {
            return;
        }
        NSString *path = [[AFDownloadRequestOperation cacheFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", media.url]];
        NSURL *url = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            url = [NSURL fileURLWithPath:path];
        }
        else {
            path = [NSString stringWithFormat:@"http://v.youku.com/player/getRealM3U8/vid/%@/type/mp4/v.m3u8", media.url];
            url = [NSURL URLWithString:path];
        }
        if (url) {
            MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC presentMoviePlayerViewControllerAnimated:vc];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view.superview endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (count == 0) {
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    else {
        self.tableView.backgroundColor = Color_ViewBg;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (void)configCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    News *news = [fetchedResultsController objectAtIndexPath:indexPath];
    [(BMHistoryTableViewCell *)cell configCellWithNews:news];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    static NSString *CellIdentifier = @"SearchCell";
    BMHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BMHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.shareButton.hidden = YES;
        cell.deleteButton.hidden = YES;
    }
    
    [self configCell:cell cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] fetchedResultsController:fetchedResultsController];
    return cell;
}

@end
