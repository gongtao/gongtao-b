//
//  BMLeftViewCell.h
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMLeftViewCell : UITableViewCell
{
    UIView *_lineView;
    UIView *_selectedBgView;
    UIView *_separatorView;
}

@property (nonatomic, assign) BOOL isCurrent;

@end
