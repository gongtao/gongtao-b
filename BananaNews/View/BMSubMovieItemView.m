//
//  BMSubMovieItemView.m
//  BananaNews
//
//  Created by 龚 涛 on 14-4-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSubMovieItemView.h"

#import "BMCustomButton.h"

#import <MediaPlayer/MediaPlayer.h>

@interface BMSubMovieItemView ()

- (NSString *)_getVideoFilePath;

- (void)_playVideo;

- (void)_buttonPressed:(UIButton *)button;

@end

@implementation BMSubMovieItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        CGRect frame = self.bounds;
        frame.size.height = 180.0;
        _bgImageView = [[UIImageView alloc] initWithFrame:frame];
        [_bgImageView setImage:[UIImage imageNamed:@"视频框背景.png"]];
        _bgImageView.contentMode = UIViewContentModeCenter;
        _bgImageView.clipsToBounds = YES;
        [self addSubview:_bgImageView];
        
        frame.size.height = 156.0;
        _contentImageView = [[UIImageView alloc] initWithFrame:frame];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
        [self addSubview:_contentImageView];
        
        frame.size.height = 180.0;
        _frameImageView = [[UIImageView alloc] initWithFrame:frame];
        [_frameImageView setImage:[UIImage imageNamed:@"视频框.png"]];
        [self addSubview:_frameImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2.0-102.0, 175.0, 204.0, 45.0)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"点击获取视频";
        [self addSubview:_titleLabel];
        
        _button = [[BMCustomButton alloc] initWithFrame:frame];
        [_button setImageRect:CGRectMake(self.bounds.size.width/2.0-20.0, 58.0, 40.0, 40.0)];
        [_button setImage:[UIImage imageNamed:@"视频框播放.png"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"视频框播放高亮.png"] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return self;
}

#pragma mark - Property

- (void)setNews:(News *)news
{
    if (_news != news) {
        _news = news;
        self.videoMedia = nil;
        self.imageMedia = nil;
        if (!_news) {
            _titleLabel.text = @"点击获取视频";
            return;
        }
        _titleLabel.text = news.title;
        [_news.medias enumerateObjectsUsingBlock:^(Media *obj, NSUInteger idx, BOOL *stop){
            if ([obj.type rangeOfString:@"image"].location == NSNotFound) {
                if (!self.videoMedia) {
                    self.videoMedia = obj;
                }
            }
            else if (!self.imageMedia) {
                self.imageMedia = obj;
            }
            if (self.imageMedia && self.videoMedia) {
                *stop = YES;
            }
        }];
    }
}

- (void)setVideoMedia:(Media *)videoMedia
{
    if (_videoMedia != videoMedia) {
        _videoMedia = videoMedia;
        if (!_videoMedia) {
            return;
        }
    }
}

- (void)setImageMedia:(Media *)imageMedia
{
    if (_imageMedia != imageMedia) {
        _imageMedia = imageMedia;
        if (!_imageMedia) {
            _contentImageView.image = nil;
            return;
        }
        [_contentImageView setImageWithURL:[NSURL URLWithString:self.imageMedia.large]];
    }
}

#pragma mark - Private

- (NSString *)_getVideoFilePath
{
    if (_videoMedia) {
        return [[AFDownloadRequestOperation cacheFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", _videoMedia.url]];
    }
    else {
        return nil;
    }
}

- (void)_playVideo
{
    NSString *path = [self _getVideoFilePath];
    NSURL *url = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        url = [NSURL fileURLWithPath:path];
    }
    else {
        path = [NSString stringWithFormat:@"http://v.youku.com/player/getRealM3U8/vid/%@/type/mp4/v.m3u8", _videoMedia.url];
        url = [NSURL URLWithString:path];
    }
    if (url) {
        NSDate *date = [NSDate new];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.news.history_day = [formatter stringFromDate:date];
        [[BMNewsManager sharedManager] saveContext];
        
        MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC presentMoviePlayerViewControllerAnimated:vc];
    }
}

- (void)_buttonPressed:(UIButton *)button
{
    [self _playVideo];
}

@end
