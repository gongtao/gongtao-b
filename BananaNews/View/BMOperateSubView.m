//
//  BMOperateSubView.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-19.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMOperateSubView.h"

@implementation BMOperateSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

//        //添加社交按钮
//        
//        //添加删除按钮
//        [_DeleteButton setBackgroundImage:[UIImage imageNamed:@"视频删除.png"] forState:UIControlStateNormal];
//        [_DeleteButton sizeToFit];
//        _DeleteButton.center=self.center;
//        [_DeleteButton addTarget:self action:@seletor(deleteButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
//        //添加分享按钮
//        [_ShareButton setBackgroundImage:[UIImage imageNamed:@"视频分享.png"] forState:UIControlStateNormal];
//        [_ShareButton sizeToFit];
//        CGPoint point=self.center;
//        point.y+=150;
//        _ShareButton.center=point;
//        [_ShareButton addTarget:self action:@seletor(ShareButtonDidPush) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

-(void) deleteButtonDidPush
{
    
}

-(void) ShareButtonDidPush
{
    
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
