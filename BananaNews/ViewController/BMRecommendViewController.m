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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginToSite:) name:kLoginSuccessNotification object:nil];
}

/*-(int)numberOfPages
{
    return 3;
}*/

-(UIView *)pageAtIndex:(NSInteger)index withFrame:(CGRect)frame;
{
    BMMovieItemView *item = [[BMMovieItemView alloc] initWithFrame:frame];
    return item;
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

-(void)videoDelete
{
    
}

-(void)videoShare
{
//    [[BMNewsManager sharedManager] shareNews:news delegate:self];
}

-(void)videoGood
{
    
}

-(void)videoBad
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

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
//        [[BMNewsManager sharedManager] shareToSite:news.nid.integerValue success:nil failure:nil];
    }
}

@end
