//
//  BMHomeTabViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMHomeTabViewController.h"

#import "BMRecommendViewController.h"

#import "AFDownloadRequestOperation.h"

#import <MediaPlayer/MediaPlayer.h>

@interface BMHomeTabViewController ()

@property (nonatomic, strong) BMToolBar *toolBar;

- (void)_selectSubVCAtIndex:(NSUInteger)index;

@end

@implementation BMHomeTabViewController

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
    self.navigationController.navigationBarHidden = YES;
    
    CGFloat y = IS_IOS7?64.0:44.0;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, y, 320.0, self.view.frame.size.height-y-48.0)];
    self.contentView.backgroundColor = Color_ViewBg;
    [self.view addSubview:self.contentView];
    
    self.customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, y)];
    self.customNavigationBar.backgroundColor = Color_NavBarBg;
    [self.view addSubview:self.customNavigationBar];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(122.0, y-31.0, 76.0, 18.0)];
    titleView.image = [UIImage imageNamed:@"芝麻短片logo.png"];
    [self.customNavigationBar addSubview:titleView];
    
    self.subVCDic = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    self.toolBar = [[BMToolBar alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.contentView.frame), 320.0, 48.0)];
    self.toolBar.delegate = self;
    [self.view addSubview:self.toolBar];
    [self.toolBar selectedTagAtIndex:0];
    
    //获取配置信息
    [[BMNewsManager sharedManager] configInit:^(void){
        [[BMNewsManager sharedManager] getConfigSuccess:^(void){
        }
                                                failure:nil];
    }];
    
#warning 测试
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
//    
//    [[BMNewsManager sharedManager] getDownloadVideoUrl:@"XNjU4MzUyNDQw" success:^(NSString *url){
//        [[BMNewsManager sharedManager] getDownloadVideo:@"XNjU4MzUyNDQw" url:url success:^(void){
//            NSString *url = [[AFDownloadRequestOperation cacheFolder] stringByAppendingPathComponent:@"XNjU4MzUyNDQw.mp4"];
//            MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
//            [self presentMoviePlayerViewControllerAnimated:vc];
//        } failure:nil];
//    } failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)notice:(NSNotification *)notice
//{
//    NSNumber *status = notice.userInfo[AFNetworkingReachabilityNotificationStatusItem];
//    switch (status.integerValue) {
//        case AFNetworkReachabilityStatusUnknown:
//        case AFNetworkReachabilityStatusNotReachable: {
//            NSLog(@"网络不给力");
//            break;
//        }
//        case AFNetworkReachabilityStatusReachableViaWWAN: {
//            NSLog(@"WWAN");
//            break;
//        }
//        case AFNetworkReachabilityStatusReachableViaWiFi: {
//            NSLog(@"WIFI");
//            break;
//        }
//        default:
//            break;
//    }
//}

#pragma mark - Private

- (void)_selectSubVCAtIndex:(NSUInteger)index
{
    NSString *identifier = nil;
    switch (index) {
        case 0: {
            identifier = @"recommendViewController";
            break;
        }
        case 1: {
            identifier = @"subCategoryViewController";
            break;
        }
        case 2: {
            identifier = @"subUserViewController";
            break;
        }
        case 3: {
            identifier = @"subSettingsViewController";
            break;
        }
        default:
            break;
    }
    if (identifier) {
        if (self.currentVC) {
            [self.currentVC.view removeFromSuperview];
            [self.currentVC removeFromParentViewController];
            self.currentVC = nil;
        }
        self.currentVC = [self.subVCDic objectForKey:identifier];
        if (!self.currentVC) {
            self.currentVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
            self.currentVC.view.frame = self.contentView.bounds;
            [self.subVCDic setObject:self.currentVC forKey:identifier];
        }
        [self.contentView addSubview:self.currentVC.view];
        [self addChildViewController:self.currentVC];
        self.index = index;
    }
}

#pragma mark - BMToolBarDelegate

- (void)didSelectTagAtIndex:(NSUInteger)index
{
    [self _selectSubVCAtIndex:index];
}

@end
