//
//  BMPageViewController.h
//  BananaNews
//
//  Created by 龚涛 on 1/10/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "GTTableViewController.h"

#import "BMTabViewController.h"

#import "GTCyclePageView.h"

@interface BMPageViewController : UIViewController <GTCyclePageViewDataSource, GTCyclePageViewDelegate, BMTabViewControllerDelegate>

@property (nonatomic, strong) BMTabViewController *tabViewController;

@property (nonatomic, strong) GTCyclePageView *pageView;

@end
