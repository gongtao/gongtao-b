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
    self.view.backgroundColor = Color_ViewBg;
    
    CGFloat y = IS_IOS7?64.0:44.0;
    
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, y)];
    navigationBar.backgroundColor = Color_CommentBlue;
    [self.view addSubview:navigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, y-44.0, self.view.frame.size.width, 44.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"评论";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:Comment_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kCommentDate ascending:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"news.nid == %@",_news.nid];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];

    BMCommentTableViewController *commentVC = [[BMCommentTableViewController alloc] initWithRequest:request cacheName:@"cacheCommentData"];
    //commentVC.view.frame = self.view.bounds;
    commentVC.view.frame=CGRectMake(0, 32, self.view.bounds.size.width, self.view.bounds.size.height-85);
    //commentVC.tableView.frame = self.view.bounds;
    commentVC.tableView.frame=CGRectMake(0, 32, self.view.bounds.size.width, self.view.bounds.size.height-85);
    commentVC.news = _news;
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
