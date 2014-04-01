//
//  BMVideoCommentCell.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-30.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMVideoCommentCell.h"

@implementation BMVideoCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.viewForBaselineLayout.backgroundColor=Color_ViewBg;
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        lineView.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
        [self.contentView addSubview:lineView];
        _dingButton=[[UIButton alloc]initWithFrame:CGRectMake(270, 70, 15, 15)];
        [_dingButton setImage:[UIImage imageNamed:@"评论顶.png"]  forState:UIControlStateNormal];
        [self.contentView addSubview:_dingButton];
        
        
        _deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(240, 70, 13, 15)];
        [_deleteButton setImage:[UIImage imageNamed:@"评论删除.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteButton];
        
        _userImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        //_userImage.image=[UIImage imageNamed:@"评论头像.png"];
        
        [self.contentView addSubview:_userImage];
        
        _userName=[[UILabel alloc]initWithFrame:CGRectMake(90, 15, 220, 15)];
        _userName.backgroundColor=[UIColor clearColor];
        _userName.font=[UIFont fontWithName:@"<#string#>" size:24];
        _userName.textColor=[UIColor colorWithHexString:@"38b7ea"];
        _userName.numberOfLines=1;
        [self.contentView addSubview:_userName];
        
        _content=[[UILabel alloc]initWithFrame:CGRectMake(90, 30, 220, 40)];
        _content.backgroundColor=[UIColor clearColor];
        _content.font=[UIFont fontWithName:@"" size:24];
        _content.textColor=[UIColor colorWithHexString:@"666666"];
        _content.numberOfLines=2;
        [self.contentView addSubview:_content];
        
        _time=[[UILabel alloc]initWithFrame:CGRectMake(90, 70, 150, 15)];
        _time.backgroundColor=[UIColor clearColor];
        _time.font=[UIFont fontWithName:@"" size:24];
        _time.textColor=[UIColor colorWithHexString:@"cccccc"];
        _time.numberOfLines=1;
        [self.contentView addSubview:_time];

        
        _dingNumber=[[UILabel alloc]initWithFrame:CGRectMake(295, 70, 15, 15)];
        _dingNumber.font=[UIFont fontWithName:@"" size:24];
        _dingNumber.textColor=[UIColor colorWithHexString:@"cccccc"];
        [self.contentView addSubview:_dingNumber];
        
    }
    return self;
}

-(void)configCellComment:(Comment *)comment
{
    _userName.text=comment.author.name;
    _content.text=comment.content;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:comment.date];
    _time.text=destDateString;
    _dingNumber.text=[[[NSNumberFormatter alloc]init]stringFromNumber:comment.ding];
    [_userImage setImageWithURL:[NSURL URLWithString:comment.author.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
    }];
    UIImage *image1=_userImage.image;
    UIImage *image2=[UIImage imageNamed:@"评论头像.png"];
    UIGraphicsBeginImageContext([image1 size]);
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _userImage.image=newImage;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
