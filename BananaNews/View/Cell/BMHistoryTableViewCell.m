//
//  BMHistoryTableViewCell.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-23.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMHistoryTableViewCell.h"

@interface BMHistoryTableViewCell()

@property(nonatomic,strong)UIImageView *image;

@property(nonatomic,strong)UILabel *label;

@property(nonatomic,strong)UIButton *delete;

@property(nonatomic,strong)UIButton *share;

@property(nonatomic,strong)News *news;

@end

@implementation BMHistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=Color_ViewBg;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10,5, 300, 70)];
        bgView.backgroundColor=[UIColor whiteColor];
        //_imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 90, 60)];
        //[self addSubview:self.imageView];
        _delete=[[UIButton alloc]initWithFrame:CGRectMake(250, 50, 13, 15)];
        [_delete setImage:[UIImage imageNamed:@"评论删除.png"] forState:UIControlStateNormal];
        [_delete addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.delete];
        _share=[[UIButton alloc]initWithFrame:CGRectMake(280, 50, 13, 15)];
        [_share setImage:[UIImage imageNamed:@"评论顶.png"] forState:UIControlStateNormal];
        [_share addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.share];
        _label=[[UILabel alloc] initWithFrame:CGRectMake(90, 20, 150, 40)];
        _label.numberOfLines=0;
        _label.font=[UIFont boldSystemFontOfSize:12.0f];
        _label.lineBreakMode=UILineBreakModeCharacterWrap;
        _label.textColor=Color_NewsSmallFont;
        [bgView addSubview:_label];
        
        _image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 80, 60)];
        [bgView addSubview:_image];
        bgView.layer.cornerRadius=6;
        bgView.layer.borderWidth=1;
        bgView.layer.borderColor=Color_NavBarBg.CGColor;
        
        [self addSubview:bgView];
    }
    return self;
}

-(void)configCellWithNews:(News *)news
{
    _news=news;
    CGSize labelSize = [news.title sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]
                       constrainedToSize:CGSizeMake(160, 40)
                           lineBreakMode:UILineBreakModeCharacterWrap];
    _label.frame=CGRectMake(110, 20, labelSize.width, labelSize.height);
    _label.text=news.title;
    [_news.medias enumerateObjectsUsingBlock:^(Media *obj, NSUInteger idx, BOOL *stop){
        if ([obj.type rangeOfString:@"image"].location != NSNotFound) {
            [_image setImageWithURL:[NSURL URLWithString:obj.large] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            }];
        }
    }];

}

-(void)deleteButtonClick
{
    if ([_delegate respondsToSelector:@selector(deleteButtonClickAtNews:)]) {
        [_delegate deleteButtonClickAtNews:_news];
    }
}

-(void)shareButtonClick
{
    if ([_delegate respondsToSelector:@selector(shareButtonClickAtNews:)]) {
        [_delegate shareButtonClickAtNews:_news];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
