//
//  BMNewsListCell.h
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMCustomButton.h"

typedef enum {
    BMNewsListCellNormal = 0,
    BMNewsListCellCollect
}BMNewsListCellType;

@interface BMNewsListCell : UITableViewCell
{
    UIView *_newsContentView;
    
    UIView *_lineView1;
    UIView *_lineView2;
    
    UILabel *_timeLabel;
}

@property (nonatomic, strong) UILabel *newsTitleLabel;

@property (nonatomic, strong) BMCustomButton *dingButton;

@property (nonatomic, strong) BMCustomButton *shareButton;

@property (nonatomic, strong) BMCustomButton *collectButton;

@property (nonatomic, assign) BMNewsListCellType type;

- (void)configCellNews:(News *)news;

@end
