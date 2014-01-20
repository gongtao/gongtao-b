//
//  BMCommentCell.h
//  BananaNews
//
//  Created by 龚涛 on 1/20/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMCommentCell : UITableViewCell
{
    UIView *_newsContentView;
    UIView *_lineView;
    
    UILabel *_commentLabel;
    UILabel *_replyLabel;
    UILabel *_timeLabel;
    
    UIImageView *_userImageView;
}

@property (nonatomic, strong) UIButton *userButton;

@property (nonatomic, strong) UIButton *replyButton;

- (void)configCellComment:(Comment *)comment isLast:(BOOL)isLast;

@end
