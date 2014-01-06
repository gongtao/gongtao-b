//
//  BMRootViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMRootViewController.h"

#import "BMNavBackButton.h"

#import "IIViewDeckController.h"

@interface BMRootViewController ()

- (void)_backButtonPressed:(id)sender;

@end

@implementation BMRootViewController

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
    
    if (self.title && self.title.length>0) {
        BMNavBackButton *button = [[BMNavBackButton alloc] init];
        [button setTitle:self.title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        self.customNavigationBar.leftView = button;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (title && title.length>0) {
        BMNavBackButton *button = nil;
        if (self.customNavigationBar.leftView) {
            button = (BMNavBackButton *)self.customNavigationBar.leftView;
            [button setTitle:self.title forState:UIControlStateNormal];
            [button sizeToFit];
        }
        else {
            button = [[BMNavBackButton alloc] init];
            [button setTitle:self.title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(_backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            self.customNavigationBar.leftView = button;
        }
    }
    else {
        self.customNavigationBar.leftView = nil;
    }
}

#pragma mark - Private

- (void)_backButtonPressed:(id)sender
{
    if ([self.navigationController viewControllers].count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.viewDeckController openLeftViewAnimated:YES];
    }
}

@end
