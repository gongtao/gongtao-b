//
//  BMSettingTableViewController.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-15.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSettingTableViewController.h"

@interface BMSettingTableViewController ()
{
    CGFloat cellHeight;
}

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


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor=Color_ViewBg;
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, cellHeight)];
    [button setTitleColor:Color_NewsSmallFont forState:UIControlStateNormal];
    [button setTitleColor:Color_NavBarBg forState:UIControlStateHighlighted];
    button.titleLabel.font=[UIFont systemFontOfSize:12.0];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    button.backgroundColor=[UIColor whiteColor];
    button.tag=100+[indexPath row];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineView.backgroundColor=Color_NavBarBg;
    [button addSubview:lineView];
    switch ([indexPath row]) {
        case 0:
            [button setTitle:@"意见反馈" forState:UIControlStateNormal];
            break;
        case 1:
            [button setTitle:@"给我评分" forState:UIControlStateNormal];
            break;
        case 2:
            [button setTitle:@"检查更新" forState:UIControlStateNormal];
            break;
        case 3:
            [button setTitle:@"清除缓存" forState:UIControlStateNormal];
            break;
        case 4:
            [button setTitle:@"关于我们" forState:UIControlStateNormal];
            break;
        case 5:
        {[button setTitle:@"免责声明" forState:UIControlStateNormal];
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, cellHeight-1, self.view.frame.size.width, 1)];
            lineView.backgroundColor=Color_NavBarBg;
            [button addSubview:lineView];
            break;}
        default:
            break;
    }
    [cell addSubview:button];
    return cell;
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
