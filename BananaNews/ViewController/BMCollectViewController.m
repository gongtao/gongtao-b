//
//  BMCollectViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-2.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMCollectViewController.h"

#import "BMCollectListViewController.h"

@interface BMCollectViewController ()

@end

@implementation BMCollectViewController

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80.0, frame.origin.y+140.0, 50.0, 60.0)];
    imageView.image = [UIImage imageNamed:@"没有收藏.png"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+2.0, CGRectGetMidY(imageView.frame)-18.0, 80.0, 36.0)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"你还没有收藏\n赶快动动手指~";
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = Color_GrayFont;
    [self.view addSubview:label];
    
    BMCollectListViewController *listVC = [[BMCollectListViewController alloc] initWithNibName:nil bundle:nil];
    listVC.user = [[BMNewsManager sharedManager] getMainUser];
    listVC.view.frame = frame;
    frame.origin.y = 0.0;
    listVC.tableView.frame = frame;
    [self addChildViewController:listVC];
    [self.view addSubview:listVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
