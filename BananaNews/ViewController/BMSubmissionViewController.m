//
//  BMSubmissionViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMSubmissionViewController.h"

@interface BMSubmissionViewController ()
{
    UIScrollView *_scrollView;
    
    UIView *_contentView;
    UIView *_newsContentView;
}

- (void)_initContentView;

- (void)_updateContentView;

- (void)_submit:(UIButton *)button;

@end

@implementation BMSubmissionViewController

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
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 44., 44.)];
    [button setImage:[UIImage imageNamed:@"反馈投递.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"反馈投递.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(_submit:) forControlEvents:UIControlEventTouchUpInside];
    self.customNavigationBar.rightView = button;
    
    CGFloat y = CGRectGetMaxY(self.customNavigationBar.frame);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, y, self.view.frame.size.width, self.view.frame.size.height-y)];
    [self.view addSubview:_scrollView];
    
    [self _initContentView];
    
    [[BMNewsManager sharedManager] getSubmission:nil success:nil failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_initContentView
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(6.0, 5.0, 308.0, 200.0)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.borderWidth = 1.0;
    _contentView.layer.borderColor = Color_GrayLine.CGColor;
    _contentView.layer.cornerRadius = 2.0;
    [_scrollView addSubview:_contentView];
    
    _newsContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 308.0, 160.0)];
    _newsContentView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_newsContentView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0, 0.0, 100.0, 22.0)];
    contentLabel.text = @"添加文字";
    contentLabel.font = Font_NewsSmall;
    contentLabel.textColor = Color_NewsSmallFont;
    [_newsContentView addSubview:contentLabel];
}

- (void)_updateContentView
{
    
}

- (void)_submit:(UIButton *)button
{
    
}

@end
