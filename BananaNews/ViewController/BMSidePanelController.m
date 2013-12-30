//
//  BMSidePanelController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMSidePanelController.h"

@interface BMSidePanelController ()

@end

@implementation BMSidePanelController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
    [self setLeftController:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    [self setCenterController:[self.storyboard instantiateViewControllerWithIdentifier:@"navigationController"]];
    [self setRightController:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setLeftSize:320.0-kSidePanelLeftWidth];
    [self setRightSize:320.0-kSidePanelRightWidth];
    self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
