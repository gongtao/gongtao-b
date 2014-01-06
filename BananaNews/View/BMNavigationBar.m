//
//  BMNavigationBar.m
//  BananaNews
//
//  Created by 龚涛 on 12/31/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMNavigationBar.h"

@implementation BMNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setLeftView:(UIView *)leftView
{
    if (leftView != _leftView) {
        if (_leftView) {
            [_leftView removeFromSuperview];
            _leftView = nil;
        }
        _leftView = leftView;
        if (_leftView) {
            CGRect frame = _leftView.bounds;
            [self addSubview:_leftView];
            _leftView.center = CGPointMake(frame.size.width/2.0, self.frame.size.height-22.0);
        }
    }
}

- (void)setCenterView:(UIView *)centerView
{
    if (centerView != _centerView) {
        if (_centerView) {
            [_centerView removeFromSuperview];
            _centerView = nil;
        }
        _centerView = centerView;
        [self addSubview:_centerView];
        _centerView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height-22.0);
    }
}

- (void)setRightView:(UIView *)rightView
{
    if (rightView != _rightView) {
        if (_rightView) {
            [_rightView removeFromSuperview];
            _rightView = nil;
        }
        _rightView = rightView;
        CGRect frame = _rightView.bounds;
        [self addSubview:_rightView];
        _rightView.center = CGPointMake(self.frame.size.width-frame.size.width/2.0, self.frame.size.height-22.0);
    }
}

@end
