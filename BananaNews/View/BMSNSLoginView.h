//
//  BMSNSLoginView.h
//  BananaNews
//
//  Created by 龚涛 on 1/14/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMSNSLoginViewDelegate <NSObject>

- (void)didSelectSNS:(NSUInteger)index;

@end

@interface BMSNSLoginView : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) id<BMSNSLoginViewDelegate> delegate;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end
