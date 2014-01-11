//
//  BMTabViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/10/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMTabViewController.h"

#define kBMTabButtonTag     1000

@interface BMTabViewController ()

@property (nonatomic, strong) UIView *scrollBgView;

- (void)_tabButtonPressed:(UIButton *)button;

@end

@implementation BMTabViewController

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
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = Color_TabBar;
    _scrollView.scrollsToTop = NO;
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _scrollBgView = [[UIView alloc] init];
    _scrollBgView.backgroundColor = Color_GrayLine;
    _scrollBgView.userInteractionEnabled = YES;
    [_scrollView addSubview:_scrollBgView];
    
    _page = -1;
    
    NSArray *array = @[@"推荐", @"社会", @"娱乐", @"正能量", @"奇葩", @"故事", @"美文"];
    
    __block CGRect frame = CGRectMake(0.0, 0.0, 45.0, 32.0);
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL* stop){
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.backgroundColor = Color_TabBar;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:Color_SideFont forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kBMTabButtonTag+idx;
        [_scrollBgView addSubview:button];
        frame.origin.x += frame.size.width+1.0;
    }];
    
    frame.size.width = frame.origin.x-1.0;
    frame.origin.x = 0.0;
    _scrollBgView.frame = frame;
    
    _scrollView.contentSize = frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_tabButtonPressed:(UIButton *)button
{
    [self selectPage:button.tag-kBMTabButtonTag];
}

#pragma mark - Public

- (void)setPage:(NSUInteger)page
{
    if (page == _page) {
        return;
    }
    UIButton *button = (UIButton *)[_scrollBgView viewWithTag:page+kBMTabButtonTag];
    if (button) {
        button.backgroundColor = Color_TabBarSelect;
        [button setTitleColor:Color_NewsFont forState:UIControlStateNormal];
    }
    
    button = (UIButton *)[_scrollBgView viewWithTag:_page+kBMTabButtonTag];
    if (button) {
        button.backgroundColor = Color_TabBar;
        [button setTitleColor:Color_SideFont forState:UIControlStateNormal];
    }
    
    _page = page;
}

- (void)selectPage:(NSUInteger)page
{
    if (_page != page) {
        if ([_delegate respondsToSelector:@selector(didSelectTab:index:)]) {
            [_delegate didSelectTab:self index:page];
        }
    }
    self.page = page;
}

@end
