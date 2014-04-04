//
//  BMVideoCommentCell.h
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-30.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMCustomButton.h"

@interface BMVideoCommentCell : UITableViewCell

@property (nonatomic,strong)UIButton *dingButton;

@property (nonatomic,strong)UIButton *deleteButton;

@property (nonatomic,strong)UIImageView *userImage;

@property (nonatomic,strong)UIImageView *userFrameImage;

@property (nonatomic,strong)UILabel *userName;

@property (nonatomic,strong)UILabel *time;

@property (nonatomic,strong)UILabel *dingNumber;

@property (nonatomic,strong)UILabel *content;

@property (nonatomic,strong)UIView *lineView;



-(void)configCellComment:(Comment *)comment;

@end
