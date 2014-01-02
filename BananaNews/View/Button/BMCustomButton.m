//
//  BMCustomButton.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-2.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMCustomButton.h"

@implementation BMCustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleRect = CGRectZero;
        _imageRect = CGRectZero;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return _titleRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return _imageRect;
}

@end
