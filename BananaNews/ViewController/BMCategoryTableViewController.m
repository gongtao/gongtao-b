//
//  BMCategoryTableViewController.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-22.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMCategoryTableViewController.h"

@interface BMCategoryTableViewController ()
{
    NSString *_cache;
    //AFHTTPRequestOperation *_request;
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
        _fetchRequest.fetchBatchSize = 1000;
        _cache = cache;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.rowAnimation = UITableViewRowAnimationNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [NSFetchedResultsController deleteCacheWithName:[self cacheName]];
    //[self reloadTableViewDataSource];
}

- (void)reloadTableViewDataSource
{
    id appDelegate = [UIApplication sharedApplication].delegate;
    nCategoryArray=[[BMNewsManager sharedManager]getAllNewsCategory:[appDelegate managedObjectContext]];
}

- (NSFetchRequest *)fetchRequest
{
    if (_fetchRequest) {
        return _fetchRequest;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NewsCategory_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:@"category_id" ascending:NO];
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
    NewsCategory *newsCategory = [fetchedResultsController objectAtIndexPath:indexPath];
    //QFPerspectiveCell *perspectiveCell = (QFPerspectiveCell *)cell;
    //[perspectiveCell configPerspectiveCell:news];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    NSLog(@"count:%i",count);
    static NSString *CellIdentifier = @"BMNewsCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    /*if (!cell) {
        cell = [[QFPerspectiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.button.tag=100+[indexPath row];
        //NSLog(@"tag:%ld",(long)cell.button.tag);
        //[cell.button addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self configCell:cell cellForRowAtIndexPath:indexPath fetchedResultsController:fetchedResultsController];
    //[cell.contentView addSubview:cell.button];*/
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


@end
