//
//  BMHistoryTableViewController.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-23.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMHistoryTableViewController.h"

#import <MediaPlayer/MediaPlayer.h>

@interface BMHistoryTableViewController ()
{
    NSString *_cache;
}

@property (nonatomic,strong)NSFetchRequest* fetchRequest;

@end

@implementation BMHistoryTableViewController

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
        _fetchRequest.fetchBatchSize = 16;
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
    [NSFetchedResultsController deleteCacheWithName:[self cacheName]];
    //[self.tableView registerClass:[QFHistorySectionView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
}

- (void)deleteButtonClickAtNews:(News *)news
{
    news.history_day = nil;
    [[BMNewsManager sharedManager] saveContext];
}

-(void)shareButtonClickAtNews:(News *)news
{
    [[BMNewsManager sharedManager] dingToSite:news.nid.integerValue success:nil failure:nil];
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:@"history_day" ascending:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"history_day != nil"];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    //request.fetchBatchSize = 12;
    return request;
}

- (NSString *)sectionNameKeyPath
{
    return @"history_day";
}

- (NSString *)cacheName
{
    return _cache;
}

- (void)configCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    News *news = [fetchedResultsController objectAtIndexPath:indexPath];
    [(BMHistoryTableViewCell *)cell configCellWithNews:news];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    if ([indexPath section] == 0) {
        return nil;
    }
    static NSString *CellIdentifier = @"HistoryCell";
    BMHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BMHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    [self configCell:cell cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1] fetchedResultsController:fetchedResultsController];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButtonClick:(UIButton *)button
{
    
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        UITableViewHeaderFooterView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"firstHeaderView"];
        if (!sectionView) {
            sectionView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"firtsHeaderView"];
            sectionView.contentView.backgroundColor = Color_ViewBg;
            
            UIButton *userButton=[[UIButton alloc]initWithFrame:CGRectMake(130, 30, 60, 60)];
            [userButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 110, 300, 15)];
            label.textColor=Color_NavBarBg;
            label.font=[UIFont systemFontOfSize:14];
            label.textAlignment=NSTextAlignmentCenter;
            if (![[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey])
            {
                label.text=@"请登录";
                [userButton setImage:[UIImage imageNamed:@"工具栏我的高亮.png"] forState:UIControlStateNormal];
            }
            else
            {
                User *user=[[BMNewsManager sharedManager] getMainUser];
                label.text=user.name;
                UIImageView *image;
                [image setImageWithURL:[NSURL URLWithString:user.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                }];
                [userButton setImage:image.image forState:UIControlStateNormal];
                [userButton setUserInteractionEnabled:NO];
            }
            
            [sectionView addSubview:userButton];
            [sectionView addSubview:label];
        }
        return sectionView;
    }
    
    UITableViewHeaderFooterView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!sectionView) {
        sectionView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView"];
    }
    if (section==1) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 20)];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=Color_NewsSmallFont;
        label.text=@"历史记录";
        [sectionView addSubview:label];
    }
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(240, 5, 80, 15)];
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=Color_NewsSmallFont;
    id<NSFetchedResultsSectionInfo> obj = [[self.fetchedResultsController sections] objectAtIndex:section-1];
    label.text=[obj name];
    [sectionView addSubview:label];
    sectionView.contentView.backgroundColor=Color_ViewBg;
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 160.0;
    }
    return 20.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 0;
    }
    return [[[self.fetchedResultsController sections] objectAtIndex:section-1] numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

#pragma mark -

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    int number = 0;
    if ([indexPath section] < [[controller sections] count]) {
        number = [[[controller sections] objectAtIndex:[indexPath section]] numberOfObjects];
    }
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
    NSIndexPath *newIndexPath1 = [NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section+1];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            if (self.numberOfFetchLimit <= number) {
                if ([newIndexPath1 row] < self.numberOfFetchLimit) {
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.numberOfFetchLimit-1 inSection:[newIndexPath1 section]]] withRowAnimation:self.rowAnimation];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath1] withRowAnimation:self.rowAnimation];
                }
            }
            else {
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath1] withRowAnimation:self.rowAnimation];
            }
            break;
            
        case NSFetchedResultsChangeDelete:
            if (self.numberOfFetchLimit <= number) {
                if ([indexPath1 row] < self.numberOfFetchLimit) {
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath1] withRowAnimation:self.rowAnimation];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.numberOfFetchLimit-1 inSection:[indexPath1 section]]] withRowAnimation:self.rowAnimation];
                }
            }
            else {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath1] withRowAnimation:self.rowAnimation];
            }
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:self.rowAnimation];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray
                                                    arrayWithObject:indexPath1] withRowAnimation:self.rowAnimation];
            [self.tableView insertRowsAtIndexPaths:[NSArray
                                                    arrayWithObject:newIndexPath1] withRowAnimation:self.rowAnimation];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex+1] withRowAnimation:self.rowAnimation];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex+1] withRowAnimation:self.rowAnimation];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex+1] withRowAnimation:self.rowAnimation];
            break;
        case NSFetchedResultsChangeMove:
            //            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:self.rowAnimation];
            break;
            
    }
}

@end
