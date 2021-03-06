//
//  BMSidePanelController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMSidePanelController.h"

#import <MediaPlayer/MediaPlayer.h>

@interface IIViewDeckController (Custom)

- (void)notifyWillOpenSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated;

- (void)notifyWillCloseSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated;

- (void)playAppsVideo:(NSNotification *)notice;

@end

@interface BMSidePanelController ()

@end

@implementation BMSidePanelController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setLeftSize:320.0-kSidePanelLeftWidth];
    [self setRightSize:320.0-kSidePanelRightWidth];
    
    self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    
    [self setCenterController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"]];
    [self setLeftController:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    [self setRightController:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
    
    //获取配置信息
    [[BMNewsManager sharedManager] configInit:^(void){
        [[BMNewsManager sharedManager] getConfigSuccess:^(void){
        }
                                                failure:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAppsVideo:) name:PlayAppsVideoNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notifyWillOpenSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    [self.view endEditing:YES];
    [super notifyWillOpenSide:viewDeckSide animated:animated];
}

- (void)notifyWillCloseSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    [self.view endEditing:YES];
    [super notifyWillCloseSide:viewDeckSide animated:animated];
}

- (void)playAppsVideo:(NSNotification *)notice
{
    NSString *url = (NSString *)notice.object;
    NSLog(@"play video: %@", url);
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
    [self presentMoviePlayerViewControllerAnimated:vc];
}

@end
