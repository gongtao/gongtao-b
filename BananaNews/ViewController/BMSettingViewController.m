//
//  BMSettingViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-2.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSettingViewController.h"

#import "BMFeedbackViewController.h"

#import <MMProgressHUD.h>

#import <SDImageCache.h>

#import "BMSettingCell.h"

@interface BMSettingViewController ()

@property (nonatomic, strong) UITableView *tableView;

- (void)_clearCache;

@end

@implementation BMSettingViewController

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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, y, 320.0, self.view.bounds.size.height-y)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_clearCache
{
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:nil status:@"清除缓存中。。。"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //清除图片缓存
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        
        [[BMNewsManager sharedManager] clearCacheData:^(void){
            [MMProgressHUD dismissWithSuccess:@"已清除缓存" title:nil afterDelay:2];
        }];
    });
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0: {
            [self _clearCache];
            break;
        }
        case 1: {
            BMFeedbackViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"feedbackViewController"];
            [self.parentViewController.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"SettingCell";
    BMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[BMSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    switch ([indexPath row]) {
        case 0: {
            cell.textLabel.text = @"清除缓存";
            [cell setCellType:SettingCellFirstType];
            cell.accessoryView = nil;
            break;
        }
        case 1: {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"左侧Cell箭头.png"]];
            cell.accessoryView = imageView;
            cell.textLabel.text = @"意见反馈";
            [cell setCellType:SettingCellLastType];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
