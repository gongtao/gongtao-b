//
//  BMRecommendViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMRecommendViewController.h"

#import "BMMovieItemView.h"

#import "BMSNSLoginView.h"

#import "BMCommentViewController.h"

@interface BMRecommendViewController ()

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UILabel *titleLabel;

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
    
    y = IS_IPhone5_or_5s?45.0:30.0;
    
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, y)];
    self.pageLabel.backgroundColor = [UIColor clearColor];
    self.pageLabel.textColor = Color_NavBarBg;
    self.pageLabel.font = [UIFont systemFontOfSize:17.0];
    self.pageLabel.text = @"1/3";
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pageLabel];
    
    BMCommonScrollorView *scView=[[BMCommonScrollorView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, 180.0)];
    scView.dataSource = self;
    scView.delegate = self;
    [self.view addSubview:scView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.0, CGRectGetMaxY(scView.frame)-5.0, 204.0, 45.0)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginToSite:) name:kLoginSuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_loginToSite:(NSNotification *)notice
{
    User *user = notice.userInfo[@"user"];
    if (user) {
        [self _comment];
    }
}

- (void)_comment
{
    BMCommentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"commentViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)videoDelete
{
    
}

- (void)videoShare
{
//    [[BMNewsManager sharedManager] shareNews:news delegate:self];
}

- (void)videoGood
{
    
}

- (void)videoBad
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey]) {
        [self _comment];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论" message:@"亲~请先登录再评论" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"登录", nil];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"登录"]) {
        BMSNSLoginView *loginView = [[BMSNSLoginView alloc] initWithFrame:self.parentViewController.view.bounds];
        [loginView showInView:self.parentViewController.view];
    }
}

#pragma mark - UMSocialUIDelegate

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
//        [[BMNewsManager sharedManager] shareToSite:news.nid.integerValue success:nil failure:nil];
    }
}

#pragma mark - BMCommonScrollorViewDataSource

- (UIView *)pageAtIndex:(NSInteger)index withFrame:(CGRect)frame;
{
    BMMovieItemView *item = [[BMMovieItemView alloc] initWithFrame:frame];
    return item;
}

#pragma mark - BMCommonScrollorViewDataSource

- (void)commonScrollorViewDidSelectPage:(NSUInteger)index
{
    self.pageLabel.text = [NSString stringWithFormat:@"%i/3", index+1];
}

@end
