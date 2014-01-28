//
//  BMNewsListCell.m
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMNewsListCell.h"

#import "BMUtils.h"

#import "BMNewsImageView.h"

#import <UIImageView+WebCache.h>

@implementation BMNewsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _newsContentView = [[UIView alloc] init];
        _newsContentView.backgroundColor = [UIColor whiteColor];
        _newsContentView.layer.borderWidth = 1.0;
        _newsContentView.layer.borderColor = Color_GrayLine.CGColor;
        _newsContentView.layer.cornerRadius = 2.0;
        [self.contentView addSubview:_newsContentView];
        
        _newsTitleLabel = [[UILabel alloc] init];
        _newsTitleLabel.backgroundColor = [UIColor clearColor];
        _newsTitleLabel.font = Font_NewsTitle;
        _newsTitleLabel.textColor = Color_NewsFont;
        _newsTitleLabel.numberOfLines = 0;
        [_newsContentView addSubview:_newsTitleLabel];
        
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"虚线.png"]];
        [_newsContentView addSubview:_lineView1];
        
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"虚线.png"]];
        [_newsContentView addSubview:_lineView2];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = Font_NewsSmall;
        _timeLabel.textColor = Color_NewsSmallFont;
        [_newsContentView addSubview:_timeLabel];
        
        _dingButton = [[BMCustomButton alloc] init];
        _dingButton.imageRect = CGRectMake(0.0, 0.0, 30.0, 30.0);
        _dingButton.titleRect = CGRectMake(30.0, 0.0, 39.0, 30.0);
        [_dingButton setImage:[UIImage imageNamed:@"赞.png"] forState:UIControlStateNormal];
        [_dingButton setImage:[UIImage imageNamed:@"赞按下.png"] forState:UIControlStateHighlighted];
        _dingButton.titleLabel.font = Font_NewsSmall;
        [_dingButton setTitleColor:Color_NewsSmallFont forState:UIControlStateNormal];
        [_newsContentView addSubview:_dingButton];
        
        _shareButton = [[BMCustomButton alloc] init];
        _shareButton.imageRect = CGRectMake(0.0, 0.0, 30.0, 30.0);
        _shareButton.titleRect = CGRectMake(30.0, 0.0, 39.0, 30.0);
        [_shareButton setImage:[UIImage imageNamed:@"分享按钮.png"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"分享按钮按下.png"] forState:UIControlStateHighlighted];
        _shareButton.titleLabel.font = Font_NewsSmall;
        [_shareButton setTitleColor:Color_NewsSmallFont forState:UIControlStateNormal];
        [_newsContentView addSubview:_shareButton];
        
        _imageArray = [[NSMutableArray alloc] init];
        
        _type = BMNewsListCellNormal;
    }
    return self;
}

- (void)configCellNews:(News *)news
{
    CGFloat textHeight = news.text_height.floatValue;
    
    _newsTitleLabel.text = news.title;
    _newsTitleLabel.frame = CGRectMake(6.0, 6.0, 296.0, textHeight);
    
    __block CGFloat y = CGRectGetMaxY(_newsTitleLabel.frame)+5.0;
    _lineView1.frame = CGRectMake(6.0, y, 296.0, 1.0);
    
    if (!news.medias || news.medias.count == 0) {
        _newsContentView.frame = CGRectMake(6.0, 5.0, 308.0, textHeight+42.0);
        y += 1.0;
        _lineView2.hidden = YES;
    }
    else {
        textHeight += news.image_height.floatValue;
        _newsContentView.frame = CGRectMake(6.0, 5.0, 308.0, textHeight+54.0);
        
        y += 6.0;
        
        int count = news.medias.count;
        while (_imageArray.count > count) {
            UIView *view = [_imageArray lastObject];
            [view removeFromSuperview];
            [_imageArray removeLastObject];
        }
        while (_imageArray.count < count) {
            BMNewsImageView *view = [[BMNewsImageView alloc] initWithFrame:CGRectZero];
            [_newsContentView addSubview:view];
            [_imageArray addObject:view];
        }
        [_imageArray enumerateObjectsUsingBlock:^(BMNewsImageView *obj, NSUInteger idx, BOOL *stop){
            obj.imageView.image = nil;
            obj.alpha = 0.0;
        }];
        
        if (count == 1) {
            [_imageArray enumerateObjectsUsingBlock:^(BMNewsImageView *obj, NSUInteger idx, BOOL *stop){
                Media *media = news.medias[0];
                CGFloat w = media.small_width.floatValue;
                if (w > kCellSingleImgWidth) {
                    w = kCellSingleImgWidth;
                }
                CGFloat h = media.small_height.floatValue;
                if (h > kCellSingleImgHeight) {
                    h = kCellSingleImgHeight;
                }
                obj.frame = CGRectMake(6.0, y, w, h);
                [obj setImageSize:CGSizeMake(media.small_width.floatValue, media.small_height.floatValue)];
                __block BMNewsImageView *imageView = obj;
                [obj.imageView setImageWithURL:[NSURL URLWithString:media.small] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    [UIView animateWithDuration:0.3 animations:^(void){
                        imageView.alpha = 1.0;
                    }];
                }];
                y += h;
            }];
        }
        else if (count>1 && count<5) {
            __block CGFloat x = 6.0;
            [_imageArray enumerateObjectsUsingBlock:^(BMNewsImageView *obj, NSUInteger idx, BOOL *stop){
                Media *media = news.medias[idx];
                if (2 == idx) {
                    y += kCellMediumImgHeight+4.0;
                    x = 6.0;
                }
                obj.frame = CGRectMake(x, y, kCellMediumImgWidth, kCellMediumImgHeight);
                [obj setImageSize:CGSizeMake(media.small_width.floatValue, media.small_height.floatValue)];
                __block BMNewsImageView *imageView = obj;
                [obj.imageView setImageWithURL:[NSURL URLWithString:media.small] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    [UIView animateWithDuration:0.3 animations:^(void){
                        imageView.alpha = 1.0;
                    }];
                }];
                x += kCellMediumImgWidth+4.0;
            }];
            y += kCellMediumImgHeight;
        }
        else if (count>4) {
            __block CGFloat x = 6.0;
            y -= kCellSmallImgHeight+4.0;
            [_imageArray enumerateObjectsUsingBlock:^(BMNewsImageView *obj, NSUInteger idx, BOOL *stop){
                Media *media = news.medias[idx];
                if (idx%3 == 0) {
                    y += kCellSmallImgHeight+4.0;
                    x = 6.0;
                }
                obj.frame = CGRectMake(x, y, kCellSmallImgWidth, kCellSmallImgHeight);
                [obj setImageSize:CGSizeMake(media.small_width.floatValue, media.small_height.floatValue)];
                __block BMNewsImageView *imageView = obj;
                [obj.imageView setImageWithURL:[NSURL URLWithString:media.small] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    [UIView animateWithDuration:0.3 animations:^(void){
                        imageView.alpha = 1.0;
                    }];
                }];
                x += kCellSmallImgWidth+4.0;
            }];
            y += kCellSmallImgHeight;
        }
        
        y += 6.0;
        _lineView2.frame = CGRectMake(6.0, y, 296.0, 1.0);
        _lineView2.hidden = NO;
        y += 1.0;
    }
    
    _timeLabel.frame = CGRectMake(9.0, y, 100.0, 30.0);
    _timeLabel.text = [BMUtils stringIntervalFromNow:news.ndate];
    
    if (BMNewsListCellNormal == _type) {
        _dingButton.frame = CGRectMake(160.0, y, 69.0, 30.0);
        _shareButton.frame = CGRectMake(235.0, y, 69.0, 30.0);
    }
    else {
        if (!_collectButton) {
            _collectButton = [[UIButton alloc] init];
            [_newsContentView addSubview:_collectButton];
        }
        
        [_collectButton setImage:[UIImage imageNamed:@"已收藏.png"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"已收藏按下.png"] forState:UIControlStateHighlighted];
        
        _dingButton.frame = CGRectMake(125.0, y, 69.0, 30.0);
        _shareButton.frame = CGRectMake(200.0, y, 69.0, 30.0);
        _collectButton.frame = CGRectMake(275.0, y, 30.0, 30.0);
    }
    
    [_dingButton setTitle:[NSString stringWithFormat:@"(%@)", news.like_count] forState:UIControlStateNormal];
    
    [_shareButton setTitle:[NSString stringWithFormat:@"(%@)", news.share_count] forState:UIControlStateNormal];
}

@end
