//
//  BMSubCategoryDetailViewController.m
//  BananaNews
//
//  Created by 龚 涛 on 14-4-22.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSubCategoryDetailViewController.h"

@interface BMSubCategoryDetailViewController ()
{
    News *_shareNews;
}

@property (nonatomic, strong) BMOperateSubView *operateSubview;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) BMMoviePageView *pageView;

- (void)_comment;

@end

@implementation BMSubCategoryDetailViewController

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
    
    self.view.backgroundColor = Color_ViewBg;
    
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.customNavigationBar.frame), 320.0, 45.0)];
    self.pageLabel.backgroundColor = [UIColor clearColor];
    self.pageLabel.textColor = Color_NavBarBg;
    self.pageLabel.font = [UIFont systemFontOfSize:17.0];
    self.pageLabel.text = @"0/0";
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pageLabel];
    
    _pageView = [[BMMoviePageView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.pageLabel.frame), self.view.bounds.size.width, 220.0)];
    _pageView.delegate = self;
    _pageView.category = _category;
    [self.view addSubview:_pageView];
    
    self.operateSubview = [[BMOperateSubView alloc] initWithFrame:CGRectMake(65.0, CGRectGetMaxY(self.customNavigationBar.frame)+275.0, 190.0, 120.0)];
    self.operateSubview.delegate = self;
    self.operateSubview.buttonDelete.hidden = YES;
    [self.view addSubview:self.operateSubview];
    
    self.customNavigationTitle.text = _category.cname;
    
    [[BMNewsManager sharedManager] getDownloadList:_category.category_id page:1 success:nil failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCategory:(NewsCategory *)category
{
    if (_category != category) {
        _category = category;
    }
}

#pragma mark - Private

- (void)_comment
{
    News *news = [_pageView currentNews];
    if (news) {
        BMCommentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"commentViewController"];
        vc.news = news;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - BMOperateSubViewDelegate

- (void)videoShare
{
    News *news = [_pageView currentNews];
    if (news) {
        _shareNews = news;
        [[BMNewsManager sharedManager] shareNews:news delegate:self];
    }
}

- (void)videoGood
{
    News *news = [_pageView currentNews];
    if (news) {
        [[BMNewsManager sharedManager] dingToSite:news.nid.integerValue success:nil failure:nil];
    }
}

- (void)videoBad
{
    [self _comment];
}

#pragma mark - BMMoviePageViewDelegate

- (void)moviePageDidChange:(NSUInteger)page pageCount:(NSUInteger)count
{
    self.pageLabel.text = [NSString stringWithFormat:@"%i/%i", page+1, count];
}

#pragma mark - UMSocialUIDelegate

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if ((response.responseCode == UMSResponseCodeSuccess) &&
        _shareNews) {
        [[BMNewsManager sharedManager] shareToSite:_shareNews.nid.integerValue success:nil failure:nil];
    }
}

#pragma mark - BMCommentViewControllerDelegate

- (void)didCancelCommentViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
