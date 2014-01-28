//
//  BMUserSearchView.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMUserSearchView.h"

@implementation BMUserSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(6.0, 6.0, 308.0, 84.0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderWidth = 1.0;
        _contentView.layer.borderColor = Color_GrayLine.CGColor;
        _contentView.layer.cornerRadius = 2.0;
        [self addSubview:_contentView];
    }
    return self;
}

@end
