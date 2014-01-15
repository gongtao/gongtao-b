//
//  FeedbackTableViewCell.m
//  UMeng Analysis
//
//  Created by liuyu on 9/18/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "L_FeedbackTableViewCell.h"
@implementation L_FeedbackTableViewCell

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
        messageBackgroundView.image = [[UIImage imageNamed:@"反馈对话框yellow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 20, 15, 15)];
        [self.contentView insertSubview:messageBackgroundView belowSubview:self.textLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize labelSize = [self.textLabel.text sizeWithFont:Font_NewsTitle
                           constrainedToSize:CGSizeMake(250.0f, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
    
    self.textLabel.frame = CGRectMake(25.0, 12.0, 250.0, labelSize.height+6.0);
    
    messageBackgroundView.frame = CGRectMake(10.0, 9.0, labelSize.width + 30.0, labelSize.height+12.0);
}

@end
