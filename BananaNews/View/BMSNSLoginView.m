//
//  BMSNSLoginView.m
//  BananaNews
//
//  Created by 龚涛 on 1/14/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMSNSLoginView.h"

#import "BMSNSLoginButton.h"

@interface BMSNSLoginView ()

- (void)selectSNS:(UIControl *)sender;

@end

@implementation BMSNSLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor colorWithHexString:@"99000000"].CGColor;
        
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 183.0, 111.0)];
        _contentView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-20.0);
        _contentView.backgroundColor = Color_GrayLine;
        [self addSubview:_contentView];
        
        BMSNSLoginButton *button1 = [[BMSNSLoginButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 183.0, 55.0)];
        button1.titleLabel.text = @"新浪微博登录";
        [button1 addTarget:self action:@selector(selectSNS:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 0;
        button1.imageView.image = [UIImage imageNamed:@"新浪logo.png"];
        [_contentView addSubview:button1];
        
        BMSNSLoginButton *button2 = [[BMSNSLoginButton alloc] initWithFrame:CGRectMake(0.0, 56.0, 183.0, 55.0)];
        button2.titleLabel.text = @"腾讯QQ登陆";
        [button2 addTarget:self action:@selector(selectSNS:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 1;
        button2.imageView.image = [UIImage imageNamed:@"QQlogo.png"];
        [_contentView addSubview:button2];
        
        self.alpha = 0.0;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(_contentView.frame, point)) {
        
        return YES;
    }
    [self dismiss];
    return NO;
}

#pragma mark - Private

- (void)selectSNS:(UIControl *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectSNS:)]) {
        [self.delegate didSelectSNS:sender.tag];
    }
    [self dismiss];
}

#pragma mark - Public

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^(void){
        self.alpha = 1.0;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}

@end
