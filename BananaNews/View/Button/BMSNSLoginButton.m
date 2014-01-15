//
//  BMSNSLoginButton.m
//  BananaNews
//
//  Created by 龚涛 on 1/14/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMSNSLoginButton.h"

@interface BMSNSLoginButton ()
{
    UIImageView *_arrowView;
}

@end

@implementation BMSNSLoginButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textColor = Color_SideFont;
        _titleLabel.font = Font_NewsTitle;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, (self.bounds.size.height-25.0)/2.0, 25.0, 25.0)];
        [self addSubview:_imageView];
        
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(150.0, (self.bounds.size.height-15.0)/2, 15.0, 15.0)];
        _arrowView.image = [UIImage imageNamed:@"左侧Cell箭头.png"];
        [self addSubview:_arrowView];
        
        self.backgroundColor = Color_SideBg;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = Color_CellBg;
        _arrowView.image = [UIImage imageNamed:@"左侧Cell箭头选中.png"];
    }
    else {
        self.backgroundColor = Color_SideBg;
        _arrowView.image = [UIImage imageNamed:@"左侧Cell箭头.png"];
    }
}

@end
