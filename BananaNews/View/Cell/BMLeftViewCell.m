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
        self.textLabel.textAlignment = NSTextAlignmentCenter;
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
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _selectedBgView.hidden = !selected;
    _lineView.hidden = !selected;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
    _lineView.frame = CGRectMake(0.0, 0.0, 6.0, self.bounds.size.height-1.0);
    _selectedBgView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height-1.0);
    _separatorView.frame = CGRectMake(0.0, self.bounds.size.height-1.0, self.bounds.size.width, 1.0);
}

@end
