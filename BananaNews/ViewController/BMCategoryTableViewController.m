//
//  BMCategoryTableViewController.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-22.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMCategoryTableViewController.h"

#import "BMNewsCategoryTableViewCell.h"

#import "BMSubCategoryDetailViewController.h"

@interface BMCategoryTableViewController ()
{
    NSString *_cache;
    NSArray *nCategoryArray;
}

@property (nonatomic,strong)NSFetchRequest* fetchRequest;

@end

@implementation BMCategoryTableViewController

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
    [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
}

- (NSFetchRequest *)fetchRequest
{
    if (_fetchRequest) {
        return _fetchRequest;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NewsCategory_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:@"category_id" ascending:YES];
    request.predicate = [NSPredicate predicateWithFormat:@"isHead == NO"];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    return request;
}

- (NSString *)cacheName
{
    return _cache;
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

- (void)configCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    BMNewsCategoryTableViewCell *categoryCell = (BMNewsCategoryTableViewCell *)cell;
    int row=[indexPath row];
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if ([indexPath row] == count) {
        [categoryCell configCellWithString:nil atButton:row%2 isHidden:YES];
    }
    else
    {
        NewsCategory *newsCategory = [fetchedResultsController objectAtIndexPath:indexPath];
        [categoryCell configCellWithString:newsCategory.cname atButton:row%2 isHidden:NO];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    static NSString *CellIdentifier = @"BMNewsCategoryCell";
    BMNewsCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BMNewsCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self configCell:cell cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row]*2 inSection:0] fetchedResultsController:fetchedResultsController];
    [self configCell:cell cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row]*2+1 inSection:0] fetchedResultsController:fetchedResultsController];
    cell.button1.tag=100+[indexPath row]*2;
    cell.button2.tag=100+[indexPath row]*2+1;
    
    return cell;
}

-(void)buttonClick:(UIButton *)button
{
    int row=button.tag-100;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    NewsCategory *newsCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    BMSubCategoryDetailViewController *vc = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"subCategoryDetailViewController"];
    vc.category = newsCategory;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int categoryCount = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    int count=categoryCount/2;
    count=count+(categoryCount%2==0?0:1);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
}

@end
