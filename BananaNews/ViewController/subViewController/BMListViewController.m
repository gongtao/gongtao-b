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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    static NSString *CellIdentifier = @"ListCell";
    BMNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BMNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.type = self.type;
    }
    
    News *news = [fetchedResultsController objectAtIndexPath:indexPath];
    [cell configCellNews:news];
    
    return cell;
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

@end
