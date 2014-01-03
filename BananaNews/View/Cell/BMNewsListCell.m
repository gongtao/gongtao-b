//
//  BMNewsListCell.m
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMNewsListCell.h"

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
    }
    return self;
}

- (void)configCellNews:(News *)news
{
    CGFloat textHeight = news.text_height.floatValue;
    
    _newsTitleLabel.text = news.title;
    _newsTitleLabel.frame = CGRectMake(6.0, 6.0, 296.0, textHeight);
    
    CGFloat y = CGRectGetMaxY(_newsTitleLabel.frame)+5.0;
    _lineView1.frame = CGRectMake(6.0, y, 296.0, 1.0);
    
    if (!news.medias || news.medias.count == 0) {
        _newsContentView.frame = CGRectMake(6.0, 5.0, 308.0, textHeight+42.0);
        
        y += 1.0;
        _lineView2.hidden = YES;
    }
    else {
        _newsContentView.frame = CGRectMake(6.0, 5.0, 308.0, textHeight+54.0);
        
        y += 6.0;
        
#warning 添加图片
        
        _lineView1.frame = CGRectMake(6.0, y, 296.0, 1.0);
        _lineView2.hidden = NO;
        y += 1.0;
    }
    
    
}

@end
