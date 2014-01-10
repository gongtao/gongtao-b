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
    _tabViewController = [[BMTabViewController alloc] initWithNibName:nil bundle:nil];
    _tabViewController.view.frame = CGRectMake(0.0, 0.0, 320.0, 32.0);
    _tabViewController.scrollView.frame = CGRectMake(0.0, 0.0, 320.0, 32.0);
    [self addChildViewController:_tabViewController];
    [self.view addSubview:_tabViewController.view];
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_pageView reloadData];
}

#pragma mark - GTCyclePageViewDataSource

- (NSUInteger)numberOfPagesInCyclePageView:(GTCyclePageView *)cyclePageView
{
    return 5;
}

- (GTCyclePageViewCell *)cyclePageView:(GTCyclePageView *)cyclePageView index:(NSUInteger)index
{
    static NSString *identifier = @"PageViewCell";
    static int count = 0;
    GTCyclePageViewCell *cell = [cyclePageView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GTCyclePageViewCell alloc] initWithReuseIdentifier:identifier];
        
        id appDelegate = [UIApplication sharedApplication].delegate;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
        [request setEntity:entity];
        NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
        
        BMListViewController *listVC = [[BMListViewController alloc] initWithRequest:request cacheName:[NSString stringWithFormat:@"CacheData%i", count]];
        listVC.view.frame = cyclePageView.bounds;
        listVC.tableView.frame = cyclePageView.bounds;
        NSLog(@"%f", cyclePageView.bounds.size.height);
        [self addChildViewController:listVC];
        [cell addSubview:listVC.view];
        
        count++;
        NSLog(@"%i", count);
    }
    return cell;
}

#pragma mark - GTCyclePageViewDelegate

- (void)didPageChangedCyclePageView:(GTCyclePageView *)cyclePageView
{
    
}

- (void)cyclePageView:(GTCyclePageView *)cyclePageView didTouchCellAtIndex:(NSUInteger)index
{
    
}

@end
