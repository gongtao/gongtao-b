//
//  BMNewsCategoryTableViewCell.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-22.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMNewsCategoryTableViewCell.h"

@implementation BMNewsCategoryTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _button1=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 140, 140)];
        _button2=[[UIButton alloc]initWithFrame:CGRectMake(170, 5, 140, 140)];
        [self addSubview:_button1];
        [self addSubview:_button2];
    }
    return self;
};

-(void)configCellWithString:(NSString *)name atButton:(int )tag isHidden:(BOOL)is_hidden
{
    if (tag==0) {
        [_button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"分类_%@.png",name]] forState:UIControlStateNormal];
        //_button1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"分类_%@.png",name]]];
        [_button1 setHidden:is_hidden];
        
    }
    else if (tag==1)
    {
        [_button2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"分类_%@.png",name]] forState:UIControlStateNormal];
        //_button2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"分类_%@.png",name]]];
        [_button2 setHidden:is_hidden];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
