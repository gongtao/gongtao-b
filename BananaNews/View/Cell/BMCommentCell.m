//
//  BMCommentCell.m
//  BananaNews
//
//  Created by 龚涛 on 1/20/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMCommentCell.h"

#import <UIImageView+WebCache.h>

#import "BMUtils.h"

@implementation BMCommentCell

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
        
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.font = Font_NewsTitle;
        _commentLabel.textColor = Color_NewsFont;
        _commentLabel.numberOfLines = 0;
        [_newsContentView addSubview:_commentLabel];
        
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6.0, 16.0, 28.0, 28.0)];
        _userImageView.layer.cornerRadius = 2.0;
        _userImageView.clipsToBounds = YES;
        [_newsContentView addSubview:_userImageView];
        
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.backgroundColor = [UIColor clearColor];
        _replyLabel.font = Font_NewsTitle;
        _replyLabel.textColor = Color_NewsSmallFont;
        _replyLabel.text = @"回复";
        [_replyLabel sizeToFit];
        _replyLabel.hidden = YES;
        [_newsContentView addSubview:_replyLabel];
        
        _userButton = [[UIButton alloc] init];
        _userButton.backgroundColor = [UIColor clearColor];
        [_userButton setTitleColor:Color_CommentUser forState:UIControlStateNormal];
        _userButton.titleLabel.font = Font_NewsTitle;
        [_newsContentView addSubview:_userButton];
        
        _replyButton = [[UIButton alloc] init];
        _replyButton.backgroundColor = [UIColor clearColor];
        [_replyButton setTitleColor:Color_CommentUser forState:UIControlStateNormal];
        _replyButton.titleLabel.font = Font_NewsTitle;
        _replyButton.hidden = YES;
        [_newsContentView addSubview:_replyButton];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = Font_NewsSmall;
        _timeLabel.textColor = Color_NewsSmallFont;
        [_newsContentView addSubview:_timeLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color_GrayLine;
        [_newsContentView addSubview:_lineView];
    }
    return self;
}

- (void)configCellComment:(Comment *)comment isLast:(BOOL)isLast
{
    CGFloat height = comment.height.floatValue;
    
    _newsContentView.frame = CGRectMake(6.0, -3.0, 308.0, height+60.0);
    
    CGSize size = [comment.author.name sizeWithFont:Font_NewsTitle];
    _userButton.frame = CGRectMake(38.0, 12.0, size.width, size.height);
    [_userButton setTitle:comment.author.name forState:UIControlStateNormal];
    
#warning 回复评论
//    size = _replyLabel.frame.size;
//    _replyLabel.frame = CGRectMake(CGRectGetMaxX(_userButton.frame)+3.0, 12.0, size.width, size.height);
//    
//    size = [comment.author.name sizeWithFont:Font_NewsTitle];
//    _replyButton.frame = CGRectMake(CGRectGetMaxX(_replyLabel.frame)+3.0, 12.0, size.width, size.height);
//    [_replyButton setTitle:comment.author.name forState:UIControlStateNormal];
    
    NSString *time = [BMUtils stringIntervalFromNow:comment.date];
    size = [time sizeWithFont:Font_NewsSmall];
    _timeLabel.frame = CGRectMake(302.0-size.width, 12.0, size.width, size.height);
    _timeLabel.text = time;
    
    _commentLabel.frame = CGRectMake(38.0, 30.0, 257.0, height);
    _commentLabel.text = comment.content;
    
    _lineView.frame = CGRectMake(0.0, height+53.0, 308.0, 1.0);
    _lineView.hidden = isLast;
    
    _userImageView.image = nil;
    _userImageView.alpha = 0.0;
    __block UIImageView *imageView = _userImageView;
    [_userImageView setImageWithURL:[NSURL URLWithString:comment.author.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        [UIView animateWithDuration:0.3 animations:^(void){
            imageView.alpha = 1.0;
        }];
    }];
}

@end
