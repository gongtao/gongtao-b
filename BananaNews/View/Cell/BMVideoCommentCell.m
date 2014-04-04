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
        
        _lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
        [self.contentView addSubview:_lineView];
        
        _dingButton=[[UIButton alloc]initWithFrame:CGRectMake(270, 70, 15, 15)];
        [_dingButton setImage:[UIImage imageNamed:@"评论顶.png"]  forState:UIControlStateNormal];
        _dingButton.hidden = YES;
        [self.contentView addSubview:_dingButton];
        
        
        _deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(240, 70, 13, 15)];
        [_deleteButton setImage:[UIImage imageNamed:@"评论删除.png"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        [self.contentView addSubview:_deleteButton];
        
        _userImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        [self.contentView addSubview:_userImage];
        
        _userFrameImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        _userFrameImage.image=[UIImage imageNamed:@"评论头像.png"];
        [self.contentView addSubview:_userFrameImage];
        
        _userName=[[UILabel alloc]initWithFrame:CGRectMake(90, 15, 220, 15)];
        _userName.backgroundColor=[UIColor clearColor];
        _userName.font=[UIFont systemFontOfSize:14.0];
        _userName.textColor=[UIColor colorWithHexString:@"38b7ea"];
        _userName.numberOfLines=1;
        [self.contentView addSubview:_userName];
        
        _content=[[UILabel alloc]initWithFrame:CGRectMake(90, 30, 220, 40)];
        _content.backgroundColor=[UIColor clearColor];
        _content.font=[UIFont systemFontOfSize:14.0];
        _content.numberOfLines = 0;
        _content.textColor=[UIColor colorWithHexString:@"666666"];
        _content.numberOfLines=2;
        [self.contentView addSubview:_content];
        
        _time=[[UILabel alloc]initWithFrame:CGRectMake(90, 70, 150, 15)];
        _time.backgroundColor=[UIColor clearColor];
        _time.font=[UIFont systemFontOfSize:14.0];
        _time.textColor=[UIColor colorWithHexString:@"cccccc"];
        _time.numberOfLines=1;
        [self.contentView addSubview:_time];

        
        _dingNumber=[[UILabel alloc]initWithFrame:CGRectMake(295, 70, 15, 15)];
        _dingNumber.font=[UIFont systemFontOfSize:14.0];
        _dingNumber.textColor=[UIColor colorWithHexString:@"cccccc"];
        _dingNumber.hidden = YES;
        [self.contentView addSubview:_dingNumber];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _lineView.frame = CGRectMake(0, self.frame.size.height-1.0, self.frame.size.width, 1.0);
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
