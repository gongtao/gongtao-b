//
//  BMNewsListCell.h
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMNewsListCell : UITableViewCell
{
    UIView *_newsContentView;
    
    UIView *_lineView1;
    UIView *_lineView2;
}

@property (nonatomic, strong) UILabel *newsTitleLabel;

- (void)configCellNews:(News *)news;

@end
