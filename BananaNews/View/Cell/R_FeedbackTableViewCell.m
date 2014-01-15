//
//  R_FeedbackTableViewCell.m
//  UMeng Analysis
//
//  Created by liuyu on 9/18/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "R_FeedbackTableViewCell.h"

@implementation R_FeedbackTableViewCell

- (CGSize)stringCGSize:(NSString *)content font:(UIFont *)font width:(CGFloat)width {
    return [content sizeWithFont:font
               constrainedToSize:CGSizeMake(width, INT_MAX)
                   lineBreakMode:NSLineBreakByWordWrapping
    ];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = Font_NewsTitle;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentLeft;

        messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
        messageBackgroundView.image = [[UIImage imageNamed:@"反馈对话框white.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 15, 15, 20)];
        [self.contentView insertSubview:messageBackgroundView belowSubview:self.textLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self stringCGSize:self.textLabel.text font:Font_NewsTitle width:BubbleMaxWidth];

    CGRect textLabelFrame = CGRectMake(self.bounds.size.width - size.width - RightMargin, self.bounds.origin.y + 15., size.width, size.height);
    self.textLabel.frame = textLabelFrame;
    
    messageBackgroundView.frame = CGRectMake(textLabelFrame.origin.x - BubblePaddingLeft, 9.0, size.width + BubbleMarginHorizontal, size.height+12.0);
}

@end
