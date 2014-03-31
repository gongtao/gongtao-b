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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];

    BMCommentTableViewController *commentVC = [[BMCommentTableViewController alloc] initWithRequest:request cacheName:@"cacheData"];
    commentVC.view.frame = self.view.bounds;
    commentVC.tableView.frame = self.view.bounds;
    //commentVC.categoryId = category.category_id;
    [self addChildViewController:commentVC];
    [self.view addSubview:commentVC.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
