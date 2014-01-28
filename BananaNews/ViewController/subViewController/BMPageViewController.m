//
//  BMPageViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/10/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMPageViewController.h"

#import "BMListViewController.h"

@interface BMPageViewController ()

@end

@implementation BMPageViewController

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
    _tabViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabViewController"];
    _tabViewController.view.frame = CGRectMake(0.0, 0.0, 320.0, 32.0);
    _tabViewController.scrollView.frame = CGRectMake(0.0, 0.0, 320.0, 32.0);
    _tabViewController.delegate = self;
    [self.view addSubview:_tabViewController.view];
    [self addChildViewController:_tabViewController];
    
    _pageView = [[GTCyclePageView alloc] init];
    _pageView.dataSource = self;
    _pageView.delegate = self;
    [self.view addSubview:_pageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tabViewController tabsUpdate];
}

#pragma mark - GTCyclePageViewDataSource

- (NSUInteger)numberOfPagesInCyclePageView:(GTCyclePageView *)cyclePageView
{
    return [self.tabViewController pageNum];
}

- (GTCyclePageViewCell *)cyclePageView:(GTCyclePageView *)cyclePageView index:(NSUInteger)index
{
    static NSString *identifier = @"PageViewCell";
    static int count = 0;
    GTCyclePageViewCell *cell = [cyclePageView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GTCyclePageViewCell alloc] initWithReuseIdentifier:identifier];
        
        NewsCategory *category = [self.tabViewController.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        id appDelegate = [UIApplication sharedApplication].delegate;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
        [request setEntity:entity];
        NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
        request.predicate = [NSPredicate predicateWithFormat:@"category.category_id == %@",category.category_id];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
        
        BMListViewController *listVC = [[BMListViewController alloc] initWithRequest:request cacheName:[NSString stringWithFormat:@"CacheData%i", count]];
        listVC.view.frame = cyclePageView.bounds;
        listVC.tableView.frame = cyclePageView.bounds;
        listVC.categoryId = category.category_id;
        [self addChildViewController:listVC];
        [cell addSubview:listVC.view];
        
        cell.viewController = listVC;
        
        count++;
    }
    else {
        BMListViewController *listVC = (BMListViewController *)cell.viewController;
        listVC.tableView.contentOffset = CGPointZero;
        [listVC changeFetchRequest:^(NSFetchRequest *request){
            NewsCategory *category = [self.tabViewController.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            listVC.categoryId = category.category_id;
            request.predicate = [NSPredicate predicateWithFormat:@"category.category_id == %@",category.category_id];
            [listVC refreshLastUpdateTime];
        }];
        [listVC.tableView reloadData];
    }
    
    return cell;
}

#pragma mark - GTCyclePageViewDelegate

- (void)didPageChangedCyclePageView:(GTCyclePageView *)cyclePageView
{
    [_tabViewController setPage:cyclePageView.currentPage];
    GTCyclePageViewCell *cell = [cyclePageView cyclePageViewCellAtIndex:cyclePageView.currentPage];
    BMListViewController *vc = (BMListViewController *)cell.viewController;
    [vc performSelector:@selector(startLoadingTableViewData) withObject:nil afterDelay:0.3];
}

#pragma mark - BMTabViewControllerDelegate

- (void)didSelectTab:(BMTabViewController *)tabViewController index:(NSUInteger)index
{
    [_pageView setCurrentPage:index];
}

@end
