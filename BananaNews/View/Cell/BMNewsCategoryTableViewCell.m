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
        self.backgroundColor = Color_ViewBg;
        _button1=[[UIButton alloc]initWithFrame:CGRectMake(15, 5, 140, 140)];
        _button2=[[UIButton alloc]initWithFrame:CGRectMake(165, 5, 140, 140)];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        _label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 20)];
        _label1.font=[UIFont systemFontOfSize:14];
        _label1.textColor=[UIColor whiteColor];
        _label1.backgroundColor=[UIColor clearColor];
        [_button1 addSubview:_label1];
        
        _label2=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 20)];
        _label2.font=[UIFont systemFontOfSize:14];
        _label2.textColor=[UIColor whiteColor];
        _label2.backgroundColor=[UIColor clearColor];
        [_button2 addSubview:_label2];
        [self addSubview:_button1];
        [self addSubview:_button2];
    }
    return self;
};

-(void)configCellWithString:(NSString *)name atButton:(int)tag isHidden:(BOOL)is_hidden
{
    if (tag==0) {
        [_button1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"分类_%@.png",name]] forState:UIControlStateNormal];
        //_button1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"分类_%@.png",name]]];
        [_button1 setHidden:is_hidden];
        _label1.text=name;
        
    }
    else if (tag==1)
    {
        [_button2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"分类_%@.png",name]] forState:UIControlStateNormal];
        //_button2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"分类_%@.png",name]]];
        [_button2 setHidden:is_hidden];
        _label2.text=name;

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
