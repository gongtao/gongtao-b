//
//  BMSubCategoryViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMSubCategoryViewController.h"

#import "BMCategoryTableViewController.h"

//#import "BMNewsManager.h"

@interface BMSubCategoryViewController ()

@property (nonatomic, strong) BMCategoryTableViewController *newsVC;

@end

@implementation BMSubCategoryViewController

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
    CGFloat y = IS_IOS7?64.0:44.0;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName: NewsCategory_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:@"category_id" ascending:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"isHead == NO"];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    
    _newsVC = [[BMCategoryTableViewController alloc] initWithRequest:request cacheName:@"cacheCategory"];
    _newsVC.view.backgroundColor=[UIColor clearColor];
    [self addChildViewController:_newsVC];
    [self.view addSubview:_newsVC.view];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _newsVC.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _newsVC.tableView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
