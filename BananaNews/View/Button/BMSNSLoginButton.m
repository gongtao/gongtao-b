//
//  BMSNSLoginButton.m
//  BananaNews
//
//  Created by 龚涛 on 1/14/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMSNSLoginButton.h"

@implementation BMSNSLoginButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textColor = Color_SideFont;
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        self.backgroundColor = Color_SideBg;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = Color_CellBg;
    }
    else {
        self.backgroundColor = Color_SideBg;
    }
}

@end
