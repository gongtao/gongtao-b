//
//  BMSettingCell.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SettingCellNormalType,
    SettingCellFirstType,
    SettingCellLastType
}BMSettingCellType;

@interface BMSettingCell : UITableViewCell
{
    UIView *_newsContentView;
    
    UIView *_lineView;
}

- (void)setCellType:(BMSettingCellType)type;

@end
