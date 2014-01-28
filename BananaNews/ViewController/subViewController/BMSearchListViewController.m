//
//  BMSearchListViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSearchListViewController.h"

#import "BMDetailNewsViewController.h"

#import "BMUserSearchView.h"

#import "BMSearchView.h"

#import "BMNewsListCell.h"

@interface BMSearchListViewController ()

@property (nonatomic, strong) BMSearchView *searchView;

@property (nonatomic, strong) BMUserSearchView *userSearchView;

@property (nonatomic, strong) UITableViewCell *userCell;

@property (nonatomic, strong) UITableViewCell *newsInfoCell;

- (void)_searchButtonPressed:(id)sender;

- (void)_dingButtonPressed:(UIButton *)sender;

- (void)_shareButtonPressed:(UIButton *)sender;

@end

@implementation BMSearchListViewController

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
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[BMNewsManager sharedManager] clearSearchData:nil];
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

- (void)_searchButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    NSString *text = _searchView.textField.text;
    if (!text || text.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"搜索" message:@"请输入搜索关键字" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    __block BMNewsManager *manager = [BMNewsManager sharedManager];
    [manager clearSearchData:^(void){
        [manager getSearchUsers:text
                        success:^(void){
                            [manager getSearchNews:text
                                           success:^(void){
                                                
                                           }
                                           failure:^(NSError *error){
                                           }];
                        }
                        failure:^(NSError *error){
                        }];
    }];
}

#pragma mark - Override

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", kIsNewsSearch, [NSNumber numberWithBool:YES]]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    return request;
}

- (NSString *)cacheName
{
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (0 == row) {
        [_searchView becomeFirstResponder];
    }
    else if (1 == row) {
        
    }
    else if (2 == row) {
        return;
    }
    else {
        BMDetailNewsViewController *vc = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"detailNewsViewController"];
        vc.news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row-3 inSection:[indexPath section]]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (count == 0 &&
        (!_userSearchView.users || _userSearchView.users.count==0)) {
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    else {
        self.tableView.backgroundColor = Color_ContentBg;
    }
    return 3+count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath row]) {
        return 55.0;
    }
    if (1 == [indexPath row]) {
        if (!_userSearchView.users || _userSearchView.users.count==0) {
            return 0.0;
        }
        return 96.0;
    }
    NSInteger count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (2 == [indexPath row]) {
        if (count > 0) {
            return 30.0;
        }
        else {
            return 0.0;
        }
    }
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row]-3 inSection:0]];
    if (!news.medias || news.medias.count == 0) {
        return news.text_height.floatValue+52.0;
    }
    return news.text_height.floatValue+news.image_height.floatValue+64.0;
}

- (void)configCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    NSInteger row = [indexPath row];
    News *news = [fetchedResultsController objectAtIndexPath:indexPath];
    BMNewsListCell *newCell = (BMNewsListCell *)cell;
    [newCell configCellNews:news];
    
    newCell.dingButton.tag = row;
    newCell.shareButton.tag = row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    NSInteger row = [indexPath row];
    UITableViewCell *cell = nil;
    if (0 == row) {
        static NSString *searchIdentifier = @"searchCell";
        cell = [tableView dequeueReusableCellWithIdentifier:searchIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            if (_searchView) {
                [_searchView removeFromSuperview];
            }
            else {
                _searchView = [[BMSearchView alloc] initWithFrame:CGRectMake(6.0, 9.0, 308.0, 40.0)];
                _searchView.textField.delegate = self;
                [_searchView.searchButton addTarget:self action:@selector(_searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell.contentView addSubview:_searchView];
        }
    }
    else if (1 == row) {
        if (!_userCell) {
            _userCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            _userCell.backgroundColor = [UIColor clearColor];
            
            _userSearchView = [[BMUserSearchView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 96.0)];
            [_userCell.contentView addSubview:_userSearchView];
        }
        return _userCell;
    }
    else if (2 == row) {
        if (!_newsInfoCell) {
            _newsInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            _newsInfoCell.backgroundColor = [UIColor clearColor];
        }
        return _newsInfoCell;
    }
    else {
        static NSString *CellIdentifier = @"ListCell";
        BMNewsListCell *newCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!newCell) {
            newCell = [[BMNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            newCell.type = BMNewsListCellNormal;
            [newCell.dingButton addTarget:self action:@selector(_dingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [newCell.shareButton addTarget:self action:@selector(_shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self configCell:newCell cellForRowAtIndexPath:[NSIndexPath indexPathForItem:row-3 inSection:[indexPath section]] fetchedResultsController:fetchedResultsController];
        cell = newCell;
    }
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self _searchButtonPressed:nil];
    return YES;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:[indexPath row]+3 inSection:[indexPath section]];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:[newIndexPath row]+3 inSection:[newIndexPath section]];
    
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath1 forChangeType:type newIndexPath:indexPath2];
}

#pragma mark - UMSocialUIDelegate

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    News *news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:_postId inSection:0]];
    [[BMNewsManager sharedManager] shareToSite:news.nid.integerValue success:nil failure:nil];
}

@end
