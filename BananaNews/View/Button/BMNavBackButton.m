//
//  BMNavBackButton.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMNavBackButton.h"

@implementation BMNavBackButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"导航返回.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"导航返回.png"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(32.0, 0.0, contentRect.size.width-32.0, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(-8.0, 0.0, 44.0, 44.0);
}

@end
