//
//  BMRightViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMRightViewController.h"

#import "BMLeftViewController.h"

#import "IIViewDeckController.h"

#import "BMCustomButton.h"

#import "UMSocial.h"

#define kLoginButtonWidth       130.0

@interface BMRightViewController ()
{
    BMCustomButton *_loginButton;
}

- (void)_loginButtonPressed:(id)sender;

- (void)_submitButtonPressed:(id)sender;

- (void)_collectButtonPressed:(id)sender;

- (void)_settingButtonPressed:(id)sender;

@end

@implementation BMRightViewController

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
    self.view.backgroundColor = Color_SideBg;
    
    CGFloat y = IS_IOS7 ? 35.0 : 15.0;
    
    UIImage *image = [UIImage imageNamed:@"右侧未登录头像.png"];
    NSString *title = @"登 录";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey]) {
        image = [UIImage imageNamed:@"右侧已登录头像.png"];
        NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
        UMSocialAccountEntity *sinaAccount = [snsAccountDic valueForKey:UMShareToSina];
        title = sinaAccount.userName;
    }
    
    CGFloat offset = (kLoginButtonWidth-75.0)/2;
    _loginButton = [[BMCustomButton alloc] initWithFrame:CGRectMake(320.0-(kSidePanelRightWidth+kLoginButtonWidth)/2, y, kLoginButtonWidth, 100.0)];
    _loginButton.imageRect = CGRectMake(offset, 0.0, 75.0, 75.0);
    _loginButton.titleRect = CGRectMake(0.0, 75.0, kLoginButtonWidth, 25.0);
    [_loginButton setImage:image forState:UIControlStateNormal];
    [_loginButton setImage:image forState:UIControlStateHighlighted];
    [_loginButton setTitle:title forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_loginButton setTitleColor:Color_SideFont forState:UIControlStateNormal];
    _loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_loginButton addTarget:self action:@selector(_loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    offset = (kSidePanelRightWidth-146.0)/2;
    y = CGRectGetMaxY(_loginButton.frame)+35.0;
    BMCustomButton *submitButton = [[BMCustomButton alloc] initWithFrame:CGRectMake(320.0-kSidePanelRightWidth+offset, y, 58.0, 63.0)];
    submitButton.imageRect = CGRectMake(9.0, 0.0, 40.0, 40.0);
    submitButton.titleRect = CGRectMake(0.0, 40.0, 58.0, 23.0);
    [submitButton setImage:[UIImage imageNamed:@"右侧投稿.png"] forState:UIControlStateNormal];
    [submitButton setImage:[UIImage imageNamed:@"右侧投稿按下.png"] forState:UIControlStateHighlighted];
    [submitButton setTitle:@"投 稿" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [submitButton setTitleColor:Color_SideFont forState:UIControlStateNormal];
    submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [submitButton addTarget:self action:@selector(_submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    BMCustomButton *collectButton = [[BMCustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(submitButton.frame)+30.0, y, 58.0, 63.0)];
    collectButton.imageRect = CGRectMake(9.0, 0.0, 40.0, 40.0);
    collectButton.titleRect = CGRectMake(0.0, 40.0, 58.0, 23.0);
    [collectButton setImage:[UIImage imageNamed:@"右侧收藏.png"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"右侧收藏按下.png"] forState:UIControlStateHighlighted];
    [collectButton setTitle:@"收 藏" forState:UIControlStateNormal];
    collectButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [collectButton setTitleColor:Color_SideFont forState:UIControlStateNormal];
    collectButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [collectButton addTarget:self action:@selector(_collectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectButton];
    
    y = self.view.frame.size.height-32.0;
    BMCustomButton *settingButton = [[BMCustomButton alloc] initWithFrame:CGRectMake(320.0-kSidePanelRightWidth, y, 64.0, 28.0)];
    settingButton.imageRect = CGRectMake(7.0, 4.0, 20.0, 20.0);
    settingButton.titleRect = CGRectMake(30.0, 0.0, 34.0, 28.0);
    [settingButton setImage:[UIImage imageNamed:@"右侧设置.png"] forState:UIControlStateNormal];
    [settingButton setImage:[UIImage imageNamed:@"右侧设置按下.png"] forState:UIControlStateHighlighted];
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    settingButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [settingButton setTitleColor:Color_SideFont forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(_settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [NSString stringWithFormat:@"V%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(207.0, y, 100.0, 28.0)];
    label.text = app_Version;
    label.textColor = Color_SideFont;
    label.font = [UIFont systemFontOfSize:10.0];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_loginButtonPressed:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey]) {
#warning 显示个人信息
    }
    else {
        if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina] ||
            [UMSocialAccountManager isOauthWithPlatform:UMShareToQQ]) {
#warning 网站登陆
//            [UMSocialSnsService presentSnsIconSheetView:self.parentViewController appKey:nil shareText:@"haha" shareImage:nil shareToSnsNames:nil delegate:nil];
        }
        else {
            BMSNSLoginView *loginView = [[BMSNSLoginView alloc] initWithFrame:self.view.bounds];
            loginView.delegate = self;
            [loginView showInView:self.parentViewController.view];
        }
    }
}

- (void)_submitButtonPressed:(id)sender
{
    BMLeftViewController *leftVC = (BMLeftViewController *)self.viewDeckController.leftController;
    int row = [[[leftVC.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]+1;
    [leftVC selectVCAtIndex:row];
    [self.viewDeckController closeRightViewAnimated:YES];
}

- (void)_collectButtonPressed:(id)sender
{
    BMLeftViewController *leftVC = (BMLeftViewController *)self.viewDeckController.leftController;
    [leftVC deselectVC];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"collectViewController"];
    self.viewDeckController.centerController = vc;
    [self.viewDeckController closeRightViewAnimated:YES];
}

- (void)_settingButtonPressed:(id)sender
{
    BMLeftViewController *leftVC = (BMLeftViewController *)self.viewDeckController.leftController;
    [leftVC deselectVC];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingViewController"];
    self.viewDeckController.centerController = vc;
    [self.viewDeckController closeRightViewAnimated:YES];
}

#pragma mark - BMSNSLoginViewDelegate

- (void)didSelectSNS:(NSUInteger)index
{
    NSString *sns = UMShareToSina;
    if (1 == index) {
        sns = UMShareToQQ;
    }
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:sns];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
#warning 网站登陆
//        NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
//        UMSocialAccountEntity *sinaAccount = [snsAccountDic valueForKey:UMShareToSina];
//        [_loginButton setTitle:sinaAccount.userName forState:UIControlStateNormal];
    });
}

@end
