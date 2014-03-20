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
    self.operateSubview = [[BMOperateSubView alloc] initWithFrame:CGRectMake(130, 65, 380, 85)];
    self.operateSubview.delegate = self;
    [self.view addSubview:self.operateSubview];
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
