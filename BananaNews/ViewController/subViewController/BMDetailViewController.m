//
//  BMDetailViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/9/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMDetailViewController.h"

#import "BMUserInfoViewController.h"

#import "BMNewsImageView.h"

#import "BMCustomButton.h"

#import "BMCommentCell.h"

#import <UIImageView+WebCache.h>

@interface BMDetailViewController ()

@property (nonatomic, strong) News *news;

@property (nonatomic, strong) UITableViewCell *newsCell;

@property (nonatomic, strong) UITableViewCell *commentCountCell;

@property (nonatomic, strong) UILabel *commentCountLabel;

- (void)_initNewsCell;

- (void)_ding:(id)sender;

- (void)_userBtnPressed:(UIButton *)button;

- (void)_replyUserBtnPressed:(UIButton *)button;

- (void)_presentUserInfo:(User *)user;

@end

@implementation BMDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRequest:(News *)news
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.news = news;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.rowAnimation = UITableViewRowAnimationNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += 40.0;
    self.tableView.contentInset = insets;
    
    [self _initNewsCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_initNewsCell
{
    _newsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsCell"];
    
    _newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _newsCell.backgroundColor = [UIColor clearColor];
    _newsCell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *newsContentView = [[UIView alloc] init];
    newsContentView.backgroundColor = [UIColor whiteColor];
    newsContentView.layer.borderWidth = 1.0;
    newsContentView.layer.borderColor = Color_GrayLine.CGColor;
    newsContentView.layer.cornerRadius = 2.0;
    [_newsCell.contentView addSubview:newsContentView];
    
    __block CGFloat y = 0.0;
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd hh:mm"];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0, y, 100.0, 25.0)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = Font_NewsSmall;
    timeLabel.textColor = Color_NewsSmallFont;
    timeLabel.text = [formatter stringFromDate:self.news.ndate];
    [newsContentView addSubview:timeLabel];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(106.0, y, 196.0, 25.0)];
    userLabel.backgroundColor = [UIColor clearColor];
    userLabel.font = Font_NewsSmall;
    userLabel.textColor = Color_NewsSmallFont;
    userLabel.text = [NSString stringWithFormat:@"来自：%@", self.news.user.name];
    userLabel.textAlignment = NSTextAlignmentRight;
    [newsContentView addSubview:userLabel];
    
    y += 25.0;
    
    UILabel *newsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0, y, 296.0, self.news.text_height.floatValue)];
    newsTitleLabel.backgroundColor = [UIColor clearColor];
    newsTitleLabel.font = Font_NewsTitle;
    newsTitleLabel.textColor = Color_NewsFont;
    newsTitleLabel.numberOfLines = 0;
    newsTitleLabel.text = self.news.title;
    [newsContentView addSubview:newsTitleLabel];
    
    y += self.news.text_height.floatValue+10.0;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(6.0, y, 296.0, 1.0)];
    lineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"虚线.png"]];
    [newsContentView addSubview:lineView1];
    
    y += 1.0;
    
    if (self.news.medias.count>0) {
        [self.news.medias.array enumerateObjectsUsingBlock:^(Media *obj, NSUInteger idx, BOOL *stop){
            y += 10.0;
            CGFloat w = obj.large_width.floatValue;
            CGFloat h = obj.large_height.floatValue;
            CGFloat p = w/h;
            if (p>2.0) {
                h = 120.0;
            }
            else {
                h = 240.0/p;
            }
            w = 240.0;
            
            BMNewsImageView *imageView = [[BMNewsImageView alloc] initWithFrame:CGRectMake(28.0, y, w, h)];
            [imageView setImageSize:CGSizeMake(obj.large_width.floatValue, obj.large_height.floatValue)];
            [newsContentView addSubview:imageView];
            imageView.alpha = 0.0;
            __block BMNewsImageView *blockView = imageView;
            [imageView.imageView setImageWithURL:[NSURL URLWithString:obj.large] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                [UIView animateWithDuration:0.3 animations:^(void){
                    blockView.alpha = 1.0;
                }];
            }];
            
            y += h;
        }];
    }
    y += 8.0;
    
    NSString *dingCount = [NSString stringWithFormat:@"(%@)", self.news.like_count];
    CGSize size = [dingCount sizeWithFont:Font_NewsTitle];
    if (size.width < 50.0) {
        size.width = 50.0;
    }
    CGFloat w = size.width+40.0;
    BMCustomButton *button = [[BMCustomButton alloc] initWithFrame:CGRectMake(148.0-w/2.0, y, w, 35.0)];
    button.titleRect = CGRectMake(40.0, 0.0, size.width, 33.0);
    [button setBackgroundImage:[[UIImage imageNamed:@"详情页赞.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17.5, 45.0, 17.5, 45.0)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"详情页赞按下.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17.5, 45.0, 17.5, 45.0)] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:dingCount forState:UIControlStateNormal];
    button.titleLabel.font = Font_NewsTitle;
    [button addTarget:self action:@selector(_ding:) forControlEvents:UIControlEventTouchUpInside];
    [newsContentView addSubview:button];
    
    y += 39.0;
    newsContentView.frame = CGRectMake(6.0, 6.0, 308.0, y);
    _newsCell.frame = CGRectMake(0.0, 0.0, 320.0, y+12.0);
}

- (void)_ding:(id)sender
{
    NSString *dingCount = [NSString stringWithFormat:@"(%i)", self.news.like_count.integerValue+1];
    CGSize size = [dingCount sizeWithFont:Font_NewsTitle];
    if (size.width < 50.0) {
        size.width = 50.0;
    }
    CGFloat w = size.width+40.0;
    BMCustomButton *button = (BMCustomButton *)sender;
    CGRect frame = button.frame;
    frame.size.width = w;
    button.titleRect = CGRectMake(40.0, 0.0, size.width, 33.0);
    [button setTitle:dingCount forState:UIControlStateNormal];
    
    [[BMNewsManager sharedManager] dingToSite:self.news.nid.integerValue success:nil failure:nil];
}

- (void)_userBtnPressed:(UIButton *)button
{
    Comment *comment = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
    [self _presentUserInfo:comment.author];
}

- (void)_replyUserBtnPressed:(UIButton *)button
{
    Comment *comment = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
    [self _presentUserInfo:comment.replyUser];
}

- (void)_presentUserInfo:(User *)user
{
    if (user) {
        BMUserInfoViewController *vc = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"userInfoViewController"];
        vc.user = user;
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - Override

- (NSString *)cacheName
{
    return nil;
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:Comment_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"news.nid == %@", self.news.nid];
    
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kCommentDate ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    return request;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    if (0 == [indexPath row]) {
        return _newsCell;
    }
    else if (1 == [indexPath row]) {
        if (!_commentCountCell) {
            _commentCountCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            _commentCountCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _commentCountCell.backgroundColor = [UIColor clearColor];
            _commentCountCell.contentView.backgroundColor = [UIColor clearColor];
            _commentCountCell.clipsToBounds = YES;
            
            UIView *newsContentView = [[UIView alloc] initWithFrame:CGRectMake(6.0, 3.0, 308.0, 30.0)];
            newsContentView.backgroundColor = [UIColor whiteColor];
            newsContentView.layer.borderWidth = 1.0;
            newsContentView.layer.borderColor = Color_GrayLine.CGColor;
            newsContentView.layer.cornerRadius = 2.0;
            [_commentCountCell.contentView addSubview:newsContentView];
            
            _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0, 0.0, 296.0, 27.0)];
            _commentCountLabel.backgroundColor = [UIColor clearColor];
            _commentCountLabel.font = Font_NewsTitle;
            _commentCountLabel.textColor = Color_NewsFont;
            [newsContentView addSubview:_commentCountLabel];
            
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(6.0, 26.0, 296.0, 1.0)];
            lineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"虚线.png"]];
            [newsContentView addSubview:lineView1];
        }
        _commentCountLabel.text = [NSString stringWithFormat:@"%@条吐槽", self.news.comment_count];
        return _commentCountCell;
    }
    static NSString *CellIdentifier = @"CommentCell";
    BMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BMCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.userButton addTarget:self action:@selector(_userBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.replyButton addTarget:self action:@selector(_replyUserBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self configCell:cell cellForRowAtIndexPath:indexPath fetchedResultsController:fetchedResultsController];
    return cell;
}

- (void)configCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    int row = indexPath.row-2;
    Comment *comment = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
    BMCommentCell *commentCell = (BMCommentCell *)cell;
    [commentCell configCellComment:comment isLast:(indexPath.row-1 == [fetchedResultsController.fetchedObjects count])];
    commentCell.userButton.tag = row;
    commentCell.replyButton.tag = row;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:[newIndexPath row]+2 inSection:[newIndexPath section]];
    
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath1 forChangeType:type newIndexPath:indexPath2];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath row] || 1 == [indexPath row]) {
        return;
    }
    Comment *comment = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row]-2 inSection:[indexPath section]]];
    User *user = [[BMNewsManager sharedManager] getMainUser];
    if (user.uid.integerValue != comment.author.uid.integerValue) {
        if ([self.delegate respondsToSelector:@selector(willReplyComment:)]) {
            [self.delegate willReplyComment:comment];
        }
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath row]) {
        return _newsCell.frame.size.height;
    }
    if (1 == [indexPath row]) {
        if ([self.fetchedResultsController.fetchedObjects count] > 0) {
            return 30.0;
        }
        else {
            return 0.0;
        }
    }
    Comment *comment = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:indexPath.section]];
    if (indexPath.row-1 == [self.fetchedResultsController.fetchedObjects count]) {
        return 60.0+comment.height.floatValue;
    }
    return 54.0+comment.height.floatValue;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.fetchedResultsController.fetchedObjects count];
    if (count > 0) {
        return count+2;
    }
    return 2;
}

@end
