//
//  BMOperateSubView.h
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-19.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMOperateSubViewDelegate <NSObject>

//-(void)didSelectButtonAtTag:(NSUInteger)tag;

//-(void)videoOperation:(UIButton *)button buttonState:(BOOL *)clicked;

-(void)videoDelete;

-(void)videoShare;

-(void)videoGood;

-(void)videoBad;

@end

@interface BMOperateSubView : UIView
{
    BOOL _isHidden;
}

@property (nonatomic,weak) id<BMOperateSubViewDelegate> delegate;

@property (nonatomic,strong) UIButton *buttonGood;

@property (nonatomic,strong) UIButton *buttonComment;


@end
