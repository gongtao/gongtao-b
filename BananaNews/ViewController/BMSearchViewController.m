//
//  BMSearchViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-2.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSearchViewController.h"

#import "BMSearchListViewController.h"

@interface BMSearchViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

@end

@implementation BMSearchViewController

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
    
    CGFloat y = CGRectGetMaxY(self.customNavigationBar.frame);
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80.0, y+150.0, 50.0, 40.0)];
    _imageView.image = [UIImage imageNamed:@"搜索没有结果.png"];
    [self.view addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+2.0, CGRectGetMidY(_imageView.frame)-8.0, 80.0, 16.0)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"没有搜索结果~";
    _label.font = [UIFont systemFontOfSize:12.0];
    _label.textColor = Color_GrayFont;
    [self.view addSubview:_label];
    
    BMSearchListViewController *vc = [[BMSearchListViewController alloc] initWithNibName:nil bundle:nil];
    vc.view.frame = CGRectMake(0.0, y, 320.0, self.view.frame.size.height-y);
    vc.tableView.frame = vc.view.bounds;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
