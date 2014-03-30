//
//  BMMoviePlayButton.m
//  BananaNews
//
//  Created by 龚 涛 on 14-3-30.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMMoviePlayButton.h"

@implementation BMMoviePlayButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-40.0, 38.0, 80.0, 80.0)];
        _imageView.image = [UIImage imageNamed:@"视频框播放.png"];
        _imageView.hidden = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        _imageView.image = [UIImage imageNamed:@"视频框播放.png"];
    }
    else {
        _imageView.image = [UIImage imageNamed:@"视频框播放高亮.png"];
    }
}

@end
