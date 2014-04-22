//
//  BMNewsCategoryTableViewCell.h
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-22.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMNewsCategoryTableViewCell : UITableViewCell

@property (nonatomic,strong)UIButton *button1;

@property (nonatomic,strong)UIButton *button2;

@property (nonatomic,strong)UILabel *label1;

@property (nonatomic,strong)UILabel *label2;

-(void)configCellWithString:(NSString *)name atButton:(int )tag isHidden:(BOOL)is_hidden;

@end
