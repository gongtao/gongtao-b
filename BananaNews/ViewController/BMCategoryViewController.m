//
//  BMCategoryViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/6/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMCategoryViewController.h"

#import "BMListViewController.h"

@interface BMCategoryViewController ()

@property (nonatomic, strong) BMListViewController *listVC;

@end

@implementation BMCategoryViewController

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
    CGRect frame = self.view.bounds;
    frame.origin.y = CGRectGetMaxY(self.customNavigationBar.frame);
    frame.size.height -= frame.origin.y;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"category.category_id == %@",self.category.category_id];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    
    _listVC = [[BMListViewController alloc] initWithRequest:request cacheName:[NSString stringWithFormat:@"CacheCategory%@", self.category.category_id]];
    _listVC.categoryId = self.category.category_id;
    _listVC.view.frame = frame;
    frame.origin.y = 0.0;
    _listVC.tableView.frame = frame;
    [self addChildViewController:_listVC];
    [self.view addSubview:_listVC.view];
    [_listVC refreshLastUpdateTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_listVC performSelector:@selector(startLoadingTableViewData) withObject:nil afterDelay:0.3];
}

@end
