//
//  BMHistoryTableViewController.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-23.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMHistoryTableViewController.h"


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

    //[(BMHistoryTableViewCell *)cell setLastRow:(indexPath.section == [fetchedResultsController sections].count-1) && (indexPath.row == [[[fetchedResultsController sections] lastObject] numberOfObjects]-1)];
    //[(QFHistoryCell *)cell setProduct:product];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    static NSString *CellIdentifier = @"HistoryCell";
    BMHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BMHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configCell:cell cellForRowAtIndexPath:indexPath fetchedResultsController:fetchedResultsController];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!sectionView) {
        sectionView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView"];
    }
    if (section==0) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 20)];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=Color_NewsSmallFont;
        label.text=@"历史记录";
        [sectionView addSubview:label];
    }
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(240, 5, 80, 15)];
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=Color_NewsSmallFont;
    id<NSFetchedResultsSectionInfo> obj = [[self.fetchedResultsController sections] objectAtIndex:section];
    label.text=[obj name];
    [sectionView addSubview:label];
    sectionView.contentView.backgroundColor=Color_ViewBg;
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"section num %i", [[self.fetchedResultsController sections] count]);
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"section %i", section);
    //if ([[self.fetchedResultsController sections] count] == section) {
    //    return 0;
    //}
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

#pragma mark -

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:self.rowAnimation];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:self.rowAnimation];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:self.rowAnimation];
            break;
        case NSFetchedResultsChangeMove:
            //            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:self.rowAnimation];
            break;
            
    }
}

@end
