//
//  BMCommentViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/24/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMCommentViewController.h"

#import "BMCommentTableViewController.h"

@interface BMCommentViewController ()

@end

@implementation BMCommentViewController

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
    NSLog(@"%@", self.news);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:Comment_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kCommentDate ascending:NO];
    request.predicate = [NSPredicate predicateWithFormat:@" news.nid == %i",_news.nid];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];

    BMCommentTableViewController *commentVC = [[BMCommentTableViewController alloc] initWithRequest:request cacheName:@"cacheCommentData"];
    commentVC.view.frame = self.view.bounds;
    commentVC.tableView.frame = self.view.bounds;
    commentVC.news=_news;
    commentVC.dataSource=self;
    [self addChildViewController:commentVC];
    [self.view addSubview:commentVC.view];
    [commentVC startLoadingTableViewData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
