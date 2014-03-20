//
//  BMOperateSubView.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-19.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMOperateSubView.h"
#import "BMCustomButton.h"

@implementation BMOperateSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *imageName=@[@"视频操作",@"视频删除",@"视频分享"];
        __block CGFloat x=0.0;
        [imageName enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BMCustomButton *button=[[BMCustomButton alloc]initWithFrame:CGRectMake(x, 80, 80, 80)];
            button.imageRect=CGRectMake(0.0, 0.0, 80, 80);
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",obj]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(_buttonDidPush:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=idx+50;
            [self addSubview:button];
            x+=150;
            
        }];
        
        BMCustomButton *buttonGood=[[BMCustomButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        buttonGood.imageRect=CGRectMake(0, 0, 80, 80);
        [buttonGood setImage:[UIImage imageNamed:@"视频分享.png"] forState:UIControlStateNormal];
        [buttonGood addTarget:self action:@selector(_buttonDidPush:) forControlEvents:UIControlEventTouchUpInside];
        buttonGood.tag=53;
        buttonGood.hidden=NO;
        [self addSubview:buttonGood];
        
        BMCustomButton *buttonBad=[[BMCustomButton alloc]initWithFrame:CGRectMake(0, 160, 80, 80)];
        buttonBad.imageRect=CGRectMake(0, 0, 80, 80);
        [buttonBad setImage:[UIImage imageNamed:@"视频分享.png"] forState:UIControlStateNormal];
        [buttonBad addTarget:self action:@selector(_buttonDidPush:) forControlEvents:UIControlEventTouchUpInside];
        buttonBad.tag=54;
        buttonBad.hidden=NO;
        [self addSubview:buttonBad];
    }
    return self;
}
- (void)_buttonDidPush:(UIButton *)button
{
    NSInteger tag=button.tag-50;
    switch (tag) {
        case 0:
            {
                UIButton *button=(UIButton *)[self viewWithTag:3];
            if (button.hidden==NO) {
                button.hidden=YES;
            }
            else
            {
                button.hidden=NO;
            }
            break;
            }
        case 1:
            //[self videoDelete];
            if ([self.delegate respondsToSelector:@selector(videoDelete)]) {
                [self.delegate videoDelete];
            }
            break;
        case 2:
            //[self videoShare];
            if ([self.delegate respondsToSelector:@selector(videoShare)]) {
                [self.delegate videoShare];
            }
            break;
        case 3:
            if ([self.delegate respondsToSelector:@selector(videoGood)]) {
                [self.delegate videoGood];
                break;
            }
        case 4:
            if ([self.delegate respondsToSelector:@selector(videoBad)]) {
                [self.delegate videoBad];
            }
            break;
            
        default:
            break;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
