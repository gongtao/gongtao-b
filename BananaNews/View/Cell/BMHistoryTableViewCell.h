//
//  BMHistoryTableViewCell.h
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-23.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMHistoryTableViewCellDelegate <NSObject>

-(void)deleteButtonClickAtNews:(News *)news;

-(void)shareButtonClickAtNews:(News *)news;

@end

@interface BMHistoryTableViewCell : UITableViewCell

@property(nonatomic,strong)id<BMHistoryTableViewCellDelegate>delegate;

-(void)configCellWithNews:(News *)news;

@end
