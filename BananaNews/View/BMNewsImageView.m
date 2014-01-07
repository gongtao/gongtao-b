//
//  BMNewsImageView.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-7.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMNewsImageView.h"

@implementation BMNewsImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setImageSize:(CGSize)size
{
    CGFloat p = size.width/size.height;
    CGFloat p1 = self.frame.size.width/self.frame.size.height;
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    if (p > p1) {
        h = self.frame.size.height;
        w = p*h;
        _imageView.frame = CGRectMake((self.frame.size.width-w)/2, 0.0, w, h);
    }
    else {
        w = self.frame.size.width;
        h = w/p;
        _imageView.frame = CGRectMake(0.0, 0.0, w, h);
    }
}

@end
