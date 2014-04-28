//
//  BMHomeTabViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMHomeTabViewController.h"

#import "BMRecommendViewController.h"

#import "BMSubSearchViewController.h"

#import "AFDownloadRequestOperation.h"

#import "BMCustomButton.h"

#import <MediaPlayer/MediaPlayer.h>

@interface BMHomeTabViewController ()

@property (nonatomic, strong) BMToolBar *toolBar;

@property (nonatomic, strong) BMCustomButton *searchButton;

- (void)_selectSubVCAtIndex:(NSUInteger)index;

- (void)_searchButtonPressed:(UIButton *)button;

- (void)_cancelButtonPressed:(UIButton *)button;

@end

@implementation BMHomeTabViewController

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
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = Color_ViewBg;
    
    CGFloat y = IS_IOS7?64.0:44.0;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, y, 320.0, self.view.frame.size.height-y-48.0)];
    self.contentView.backgroundColor = Color_ViewBg;
    [self.view addSubview:self.contentView];
    
    self.customNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, y)];
    self.customNavigationBar.backgroundColor = Color_NavBarBg;
    [self.view addSubview:self.customNavigationBar];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(122.0, y-31.0, 76.0, 18.0)];
    titleView.image = [UIImage imageNamed:@"芝麻短片logo.png"];
    [self.customNavigationBar addSubview:titleView];
    
    self.subVCDic = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    self.toolBar = [[BMToolBar alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.contentView.frame), 320.0, 48.0)];
    //NSLog(@"%f",CGRectGetMaxY(self.contentView.frame));
    self.toolBar.delegate = self;
    [self.view addSubview:self.toolBar];
    [self.toolBar selectedTagAtIndex:0];
    
    //self.toolBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_selectSubVCAtIndex:(NSUInteger)index
{
    NSString *identifier = nil;
    if (_searchButton && _searchButton.superview) {
        [_searchButton removeFromSuperview];
    }
    switch (index) {
        case 0: {
            identifier = @"recommendViewController";
            break;
        }
        case 1: {
            identifier = @"subCategoryViewController";
            if (!_searchButton) {
                _searchButton = [[BMCustomButton alloc] initWithFrame:CGRectMake(276.0, self.customNavigationBar.frame.size.height-44.0, 44.0, 44.0)];
                _searchButton.imageRect = CGRectMake(12.0, 12.0, 20.0, 20.0);
                [_searchButton setImage:[UIImage imageNamed:@"搜索放大镜.png"] forState:UIControlStateNormal];
                [_searchButton setImage:[UIImage imageNamed:@"搜索放大镜.png"] forState:UIControlStateHighlighted];
                [_searchButton addTarget:self action:@selector(_searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.customNavigationBar addSubview:_searchButton];
            break;
        }
        case 2: {
            identifier = @"subUserViewController";
            break;
        }
        case 3: {
            identifier = @"subSettingsViewController";
            break;
        }
        default:
            break;
    }
    if (identifier) {
        if (self.currentVC) {
            [self.currentVC.view removeFromSuperview];
            [self.currentVC removeFromParentViewController];
            self.currentVC = nil;
        }
        self.currentVC = [self.subVCDic objectForKey:identifier];
        if (!self.currentVC) {
            self.currentVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
            self.currentVC.view.frame = self.contentView.bounds;
            [self.subVCDic setObject:self.currentVC forKey:identifier];
        }
        [self.contentView addSubview:self.currentVC.view];
        [self addChildViewController:self.currentVC];
        self.index = index;
    }
}

- (void)_searchButtonPressed:(UIButton *)button
{
    BMSubSearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"subSearchViewController"];
    [self presentViewController:vc animated:YES completion:^(void){
        [vc.button addTarget:self action:@selector(_cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)_cancelButtonPressed:(UIButton *)button
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BMToolBarDelegate

- (void)didSelectTagAtIndex:(NSUInteger)index
{
    [self _selectSubVCAtIndex:index];
}

@end
