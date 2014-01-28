//
//  BMUserDetailViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMUserDetailViewController.h"

#import <UIImageView+WebCache.h>

@interface BMUserDetailViewController ()

@property (nonatomic, strong) UITableViewCell *firstCell;

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *collectLabel;

@property (nonatomic, strong) UIScrollView *desScrollView;

@property (nonatomic, strong) UITableViewCell *secondCell;

- (void)_initFirstCell;

- (void)_initSecondCell;

- (void)_initUserImage;

- (void)_initDesView:(NSString *)des;

@end

@implementation BMUserDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_initFirstCell
{
    if (!_firstCell) {
        _firstCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _firstCell.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(6.0, 6.0, 308.0, 84.0)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.borderWidth = 1.0;
        contentView.layer.borderColor = Color_GrayLine.CGColor;
        contentView.layer.cornerRadius = 2.0;
        [_firstCell.contentView addSubview:contentView];
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 60.0, 60.0)];
        [self _initUserImage];
        [contentView addSubview:_avatarView];
        
        CGFloat x = CGRectGetMaxX(_avatarView.frame)+10.0;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 8.0, 100.0, 18.0)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = self.user.name;
        nameLabel.font = Font_NewsTitle;
        nameLabel.textColor = Color_NewsFont;
        [contentView addSubview:nameLabel];
        
        NSString *desInfo = @"个人简介：";
        CGSize size = [desInfo sizeWithFont:Font_NewsSmall];
        CGFloat y = CGRectGetMaxY(nameLabel.frame)+11.0;
        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, size.width, 14.0)];
        desLabel.backgroundColor = [UIColor clearColor];
        desLabel.text = @"个人简介：";
        desLabel.font = Font_NewsSmall;
        desLabel.textColor = Color_NewsFont;
        [contentView addSubview:desLabel];
        
        int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
        _collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(desLabel.frame)+10.0, size.width, 14.0)];
        _collectLabel.backgroundColor = [UIColor clearColor];
        _collectLabel.text = [NSString stringWithFormat:@"收藏数：%i", count];
        _collectLabel.font = Font_NewsSmall;
        _collectLabel.textColor = Color_NewsFont;
        [contentView addSubview:_collectLabel];
        
        x = CGRectGetMaxX(desLabel.frame);
        _desScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y-4.0, 302.0-x, 22.0)];
        _desScrollView.showsHorizontalScrollIndicator = NO;
        [contentView addSubview:_desScrollView];
        
        [[BMNewsManager sharedManager] getUserInfoById:self.user.uid.integerValue
                                               success:^(NSString *des){
                                                   [self _initUserImage];
                                                   [self _initDesView:des];
                                               }
                                               failure:nil];
    }
}

- (void)_initSecondCell
{
    if (!_secondCell) {
        _secondCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _secondCell.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6.0, 5.0, 15.0, 15.0)];
        imageView.image = [UIImage imageNamed:@"个人页收藏"];
        [_secondCell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(21.0, 5.0, 100.0, 15.0)];
        label.backgroundColor = [UIColor clearColor];
        label.font = Font_NewsSmall;
        label.textColor = Color_NewsSmallFont;
        if (self.user.isMainUser.boolValue) {
            label.text = @"我的收藏";
        }
        else {
            label.text = @"他的收藏";
        }
        [_secondCell.contentView addSubview:label];
    }
}
- (void)_initUserImage
{
    if (_avatarView.image) {
        return;
    }
    if (self.user.avatar && self.user.avatar.length > 0) {
        _avatarView.alpha = 0.0;
        __block UIImageView *weakImageView = _avatarView;
        [_avatarView setImageWithURL:[NSURL URLWithString:self.user.avatar]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                               [UIView animateWithDuration:0.3 animations:^(void){
                                   weakImageView.alpha = 1.0;
                               }];
                           }];
    }
}

- (void)_initDesView:(NSString *)des
{
    if (des.length == 0) {
        return;
    }
    CGSize size = [des sizeWithFont:Font_NewsSmall];
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, 22.0)];
    desLabel.backgroundColor = [UIColor clearColor];
    desLabel.text = des;
    desLabel.font = Font_NewsSmall;
    desLabel.textColor = Color_NewsFont;
    [_desScrollView addSubview:desLabel];
    
    size.height = 22.0;
    _desScrollView.contentSize = size;
}

#pragma mark - Override

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    int row = [indexPath row];
    if (0 == row) {
        [self _initFirstCell];
        return _firstCell;
    }
    else if (1 == row) {
        [self _initSecondCell];
        return _secondCell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row-2 inSection:[indexPath section]] fetchedResultsController:fetchedResultsController];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:[newIndexPath row]+2 inSection:[newIndexPath section]];
    
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath1 forChangeType:type newIndexPath:indexPath2];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (0 == row || 1 == row) {
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row-2 inSection:[indexPath section]]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    if (_collectLabel) {
        _collectLabel.text = [NSString stringWithFormat:@"收藏数：%i", count];
    }
    return count+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (0 == row) {
        return 94.0;
    }
    else if (1 == row) {
        return 20.0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row-2 inSection:[indexPath section]]];
}

@end
