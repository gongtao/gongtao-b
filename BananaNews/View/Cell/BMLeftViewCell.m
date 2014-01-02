//
//  BMLeftViewCell.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMLeftViewCell.h"

@implementation BMLeftViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = Color_SideBg;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:17.0];
        self.textLabel.textColor = Color_SideFont;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = Color_GayLine;
        [self.contentView insertSubview:_separatorView belowSubview:self.textLabel];
        
        _selectedBgView = [[UIView alloc] init];
        _selectedBgView.backgroundColor = Color_CellBg;
        [self.contentView insertSubview:_selectedBgView belowSubview:self.textLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color_Yellow;
        [self.contentView insertSubview:_lineView belowSubview:self.textLabel];
        
        _isCurrent = NO;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (!self.isCurrent) {
        _selectedBgView.hidden = !highlighted;
        _lineView.hidden = !highlighted;
        if (highlighted) {
            self.imageView.image = [UIImage imageNamed:@"左侧Cell箭头选中.png"];
        }
        else {
            self.imageView.image = [UIImage imageNamed:@"左侧Cell箭头.png"];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0.0, 0.0, kSidePanelLeftWidth, self.bounds.size.height);
    self.imageView.frame = CGRectMake(155.0, (self.bounds.size.height-15.0)/2, 15.0, 15.0);
    _lineView.frame = CGRectMake(0.0, 0.0, 6.0, self.bounds.size.height-1.0);
    _selectedBgView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height-1.0);
    _separatorView.frame = CGRectMake(0.0, self.bounds.size.height-1.0, self.bounds.size.width, 1.0);
}

- (void)setIsCurrent:(BOOL)isCurrent
{
    if (_isCurrent != isCurrent) {
        _isCurrent = isCurrent;
        [self _showHighlighted:isCurrent];
    }
}

- (void)_showHighlighted:(BOOL)isShow
{
    _selectedBgView.hidden = !isShow;
    _lineView.hidden = !isShow;
    if (isShow) {
        self.imageView.image = [UIImage imageNamed:@"左侧Cell箭头选中.png"];
    }
    else {
        self.imageView.image = [UIImage imageNamed:@"左侧Cell箭头.png"];
    }
}

@end
