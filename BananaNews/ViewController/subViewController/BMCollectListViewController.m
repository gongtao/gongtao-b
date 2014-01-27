//
//  BMCollectListViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-25.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMCollectListViewController.h"

#import "BMNewsListCell.h"

#import "BMDetailNewsViewController.h"

@interface BMCollectListViewController ()
{
    NSInteger _postId;
}

@property (nonatomic, assign) BMNewsListCellType type;

- (void)_dingButtonPressed:(UIButton *)sender;

- (void)_shareButtonPressed:(UIButton *)sender;

- (void)_collectButtonPressed:(UIButton *)sender;

@end

@implementation BMCollectListViewController

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
    self.rowAnimation = UITableViewRowAnimationFade;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _type = BMNewsListCellCollect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_dingButtonPressed:(UIButton *)sender
{
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [[BMNewsManager sharedManager] dingToSite:news.nid.integerValue success:nil failure:nil];
}

- (void)_shareButtonPressed:(UIButton *)sender
{
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    _postId = sender.tag;
    [[BMNewsManager sharedManager] shareNews:news delegate:self];
}

- (void)_collectButtonPressed:(UIButton *)sender
{
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [[BMNewsManager sharedManager] collectNews:news operation:NO];
    [self.tableView reloadData];
}

#pragma mark - Override

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"Any collectUsers.uid = %@", self.user.uid]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    return request;
}

- (NSString *)cacheName
{
    return nil;
}

- (void)configCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    NSInteger row = [indexPath row];
    News *news = [fetchedResultsController objectAtIndexPath:indexPath];
    BMNewsListCell *newCell = (BMNewsListCell *)cell;
    [newCell configCellNews:news];
    
    newCell.dingButton.tag = row;
    newCell.shareButton.tag = row;
    if (BMNewsListCellCollect == newCell.type) {
        newCell.collectButton.tag = row;
        [newCell.collectButton addTarget:self action:@selector(_collectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    static NSString *CellIdentifier = @"ListCell";
    BMNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BMNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.type = self.type;
        [cell.dingButton addTarget:self action:@selector(_dingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareButton addTarget:self action:@selector(_shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self configCell:cell cellForRowAtIndexPath:indexPath fetchedResultsController:fetchedResultsController];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMDetailNewsViewController *vc = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"detailNewsViewController"];
    vc.news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (!news.medias || news.medias.count == 0) {
        return news.text_height.floatValue+52.0;
    }
    return news.text_height.floatValue+news.image_height.floatValue+64.0;
}

#pragma mark - UMSocialUIDelegate

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:_postId inSection:0]];
    [[BMNewsManager sharedManager] shareToSite:news.nid.integerValue success:nil failure:nil];
}

@end
