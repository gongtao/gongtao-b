//
//  BMSettingTableViewController.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-15.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSettingTableViewController.h"

#import "BMFeedbackViewController.h"

#import "MobClick.h"

#import <MMProgressHUD.h>

@interface BMSettingTableViewController ()
{
    CGFloat cellHeight;
}

- (void)_checkUpdateFinish:(NSDictionary *)dic;

- (void)_clearCache;

@end

static NSString *cellIdentifier = @"settingCell";

@implementation BMSettingTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        cellHeight=40;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=Color_ViewBg;
    self.tableView.backgroundColor=Color_ViewBg;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor=Color_ViewBg;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 50, 20)];
    label.textColor=Color_NewsSmallFont;
    label.font=[UIFont systemFontOfSize:12.0];
    //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //button.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    label.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor whiteColor];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineView.backgroundColor=Color_NavBarBg;
    [cell addSubview:lineView];
    switch ([indexPath row]) {
        case 0:
            label.text=@"意见反馈";
            //[button setTitle:@"意见反馈" forState:UIControlStateNormal];
            break;
        case 1:
            label.text=@"给我评分";
            //[button setTitle:@"给我评分" forState:UIControlStateNormal];
            break;
        case 2:
            label.text=@"检查更新";
            //[button setTitle:@"检查更新" forState:UIControlStateNormal];
            break;
        case 3:
            label.text=@"清除缓存";
            //[button setTitle:@"清除缓存" forState:UIControlStateNormal];
            break;
        case 4:
            label.text=@"关于我们";
            //[button setTitle:@"关于我们" forState:UIControlStateNormal];
            break;
        case 5:
            label.text=@"免责声明";
        {//[button setTitle:@"免责声明" forState:UIControlStateNormal];
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, cellHeight-1, self.view.frame.size.width, 1)];
            lineView.backgroundColor=Color_NavBarBg;
            [cell addSubview:lineView];
            break;}
        default:
            break;
    }
    [cell addSubview:label];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=[indexPath row];
    switch (row) {
        case 0: {
            BMFeedbackViewController *vc = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"feedbackViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            NSString *url = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=831101575";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            break;
        }
        case 2: {
            [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
            [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
            [MMProgressHUD showWithTitle:@"新版本" status:@"正在获取更新。。。"];
            [MobClick checkUpdateWithDelegate:self selector:@selector(_checkUpdateFinish:)];
            break;
        }
        case 3: {
            [self _clearCache];
            break;
        }
        case 4: {
            break;
        }
        case 5: {
            break;
        }
        default:
            break;
    }
}

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

- (void)_checkUpdateFinish:(NSDictionary *)dic
{
    NSLog(@"app update:%@", dic);
    NSNumber *update = dic[@"update"];
    if (!update.boolValue) {
        [MMProgressHUD dismissWithError:@"没有可用更新" afterDelay:2];
    }
    else {
        [MMProgressHUD dismissWithSuccess:@"" title:nil afterDelay:0];
    }
}

-(void)buttonClick:(UIButton *)button
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
