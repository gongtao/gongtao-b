//
//  BMDetailViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/9/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMDetailViewController.h"

#import "BMNewsImageView.h"

#import "BMCustomButton.h"

#import <UIImageView+WebCache.h>

@interface BMDetailViewController ()

@property (nonatomic, strong) News *news;

@property (nonatomic, strong) UITableViewCell *newsCell;

- (void)_initNewsCell;

- (void)_ding:(id)sender;

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
    
    NSString *dingCount = @"1000000000000";
    CGSize size = [dingCount sizeWithFont:Font_NewsTitle];
    if (size.width < 50.0) {
        size.width = 50.0;
    }
    CGFloat w = size.width+40.0;
    BMCustomButton *button = [[BMCustomButton alloc] initWithFrame:CGRectMake(148.0-w/2.0, y, w, 35.0)];
    button.titleRect = CGRectMake(35.0, 0.0, size.width, 35.0);
    [button setBackgroundImage:[[UIImage imageNamed:@"详情页赞.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17.5, 45.0, 17.5, 45.0)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"详情页赞按下.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17.5, 45.0, 17.5, 45.0)] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"999+" forState:UIControlStateNormal];
    button.titleLabel.font = Font_NewsTitle;
    [button addTarget:self action:@selector(_ding:) forControlEvents:UIControlEventTouchUpInside];
    [newsContentView addSubview:button];
    
    y += 39.0;
    newsContentView.frame = CGRectMake(6.0, 6.0, 308.0, y);
    _newsCell.frame = CGRectMake(0.0, 0.0, 320.0, y+12.0);
}

- (void)_ding:(id)sender
{
    
}

#pragma mark - Override

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
    static NSString *CellIdentifier = @"CommentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    Comment *comment = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    return cell;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:[newIndexPath row]+1 inSection:[newIndexPath section]];
    
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath1 forChangeType:type newIndexPath:indexPath2];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath row]) {
        return;
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath row]) {
        return _newsCell.frame.size.height;
    }
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+[self.fetchedResultsController.fetchedObjects count];
}

@end
