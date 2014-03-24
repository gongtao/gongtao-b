//
//  BMRecommendViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMRecommendViewController.h"

@interface BMRecommendViewController ()

@end

@implementation BMRecommendViewController

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
    
    CGFloat y = IS_IPhone5_or_5s?275.0:248.0;
    
    self.operateSubview = [[BMOperateSubView alloc] initWithFrame:CGRectMake(65.0, y, 190.0, 120.0)];
    self.operateSubview.delegate = self;
    [self.view addSubview:self.operateSubview];
    
    y=IS_IPhone5_or_5s?80.0:60;
    
    BMCommonScrollorView *scView=[[BMCommonScrollorView alloc]initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, 160)];
    scView.dataSource=self;
//    scView.delegate=self;
    [self.view addSubview:scView];
}

/*-(int)numberOfPages
{
    return 3;
}*/

-(UIView *)pageAtIndex:(NSInteger)index withFrame:(CGRect)frame;
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    [imageView setImage:[UIImage imageNamed:@"视频框.png"]];
    return imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)videoDelete
{
}

-(void)videoShare
{
}

-(void)videoGood
{}

-(void)videoBad
{}

@end
