//
//  BMSubUserViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMSubUserViewController.h"

#import "BMHistoryTableViewController.h"

@interface BMSubUserViewController ()

@property (nonatomic, strong) BMHistoryTableViewController *newsVC;

@end

@implementation BMSubUserViewController

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
    self.view.backgroundColor = Color_ViewBg;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName: News_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:@"history_day" ascending:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"history_day != nil"];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    
    _newsVC = [[BMHistoryTableViewController alloc] initWithRequest:request cacheName:@"cacheCollection"];
    _newsVC.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _newsVC.tableView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _newsVC.view.backgroundColor=[UIColor clearColor];
    [self addChildViewController:_newsVC];
    [self.view addSubview:_newsVC.view];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _newsVC.view.frame = self.view.bounds;
    _newsVC.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
