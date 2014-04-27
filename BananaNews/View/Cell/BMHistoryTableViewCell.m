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
        
        _deleteButton=[[BMCustomButton alloc]initWithFrame:CGRectMake(242, 43, 29, 29)];
        _deleteButton.imageRect = CGRectMake(8, 7, 13, 15);
        [_deleteButton setImage:[UIImage imageNamed:@"我的垃圾桶.png"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"我的垃圾桶点击.png"] forState:UIControlStateHighlighted];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.deleteButton];
        
        _shareButton=[[BMCustomButton alloc]initWithFrame:CGRectMake(272, 43, 29, 29)];
        _shareButton.imageRect = CGRectMake(7, 9.5, 15, 10);
        [_shareButton setImage:[UIImage imageNamed:@"我的分享.png"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"我的分享点击.png"] forState:UIControlStateHighlighted];
        [_shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.shareButton];
        _label=[[UILabel alloc] initWithFrame:CGRectMake(90, 20, 150, 40)];
        _label.numberOfLines=0;
        _label.font=[UIFont boldSystemFontOfSize:12.0f];
        _label.textColor=Color_NewsSmallFont;
        [bgView addSubview:_label];
        
        _image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 87, 54)];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
        [bgView addSubview:_image];
        
        UIImageView *frameView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 87, 54)];
        frameView.image = [UIImage imageNamed:@"我的图片蒙版.png"];
        [bgView addSubview:frameView];
        
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
                           lineBreakMode:NSLineBreakByCharWrapping];
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
