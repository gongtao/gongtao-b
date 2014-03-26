//
//  SBMovieItemView.m
//  BananaNews
//
//  Created by 龚涛 on 3/24/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMMovieItemView.h"

@implementation BMMovieItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_bgImageView setImage:[UIImage imageNamed:@"视频框背景.png"]];
        _bgImageView.contentMode = UIViewContentModeCenter;
        _bgImageView.clipsToBounds = YES;
        [self addSubview:_bgImageView];
        
        CGRect frame = self.bounds;
        frame.size.height = 156.0;
        _contentImageView = [[UIImageView alloc] initWithFrame:frame];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_contentImageView];
        
        _frameImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_frameImageView setImage:[UIImage imageNamed:@"视频框.png"]];
        [self addSubview:_frameImageView];
        
    }
    return self;
}

@end
