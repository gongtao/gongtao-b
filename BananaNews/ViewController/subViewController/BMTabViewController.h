//
//  BMTabViewController.h
//  BananaNews
//
//  Created by 龚涛 on 1/10/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMTabViewControllerDelegate;

@interface BMTabViewController : UIViewController

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) id<BMTabViewControllerDelegate> delegate;

- (void)selectPage:(NSUInteger)page;

@end

@protocol BMTabViewControllerDelegate <NSObject>

- (void)didSelectTab:(BMTabViewController *)tabViewController index:(NSUInteger)index;

@end
