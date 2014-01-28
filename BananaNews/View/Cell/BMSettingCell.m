//
//  BMSettingCell.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMSettingCell.h"

@implementation BMSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        self.textLabel.font = Font_NewsTitle;
        self.textLabel.textColor = Color_NewsFont;
        
        _newsContentView = [[UIView alloc] initWithFrame:CGRectMake(6.0, 0.0, 308.0, 51.0)];
        _newsContentView.backgroundColor = [UIColor whiteColor];
        _newsContentView.layer.borderWidth = 1.0;
        _newsContentView.layer.borderColor = Color_GrayLine.CGColor;
        _newsContentView.layer.cornerRadius = 2.0;
        [self.contentView insertSubview:_newsContentView belowSubview:self.textLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(8.0, 44.0, 304.0, 1.0)];
        _lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"虚线.png"]];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(12.0, 0.0, 200.0, 45.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(BMSettingCellType)type
{
    CGRect frame = _newsContentView.frame;
    switch (type) {
        case SettingCellFirstType: {
            frame.origin.y = 6.0;
            _lineView.hidden = NO;
            break;
        }
        case SettingCellNormalType: {
            frame.origin.y = 3.0;
            _lineView.hidden = NO;
            break;
        }
        case SettingCellLastType: {
            frame.origin.y = -6.0;
            _lineView.hidden = YES;
            break;
        }
        default:
            break;
    }
    _newsContentView.frame = frame;
}

@end
