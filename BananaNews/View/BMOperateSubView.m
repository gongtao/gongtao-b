//
//  BMOperateSubView.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-19.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMOperateSubView.h"
#import "BMCustomButton.h"

@interface BMOperateSubView ()

- (void)_buttonDidPush:(UIButton *)button;

@end

@implementation BMOperateSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *imageName = @[@"视频操作",@"视频删除",@"视频分享"];
        
        _buttonGood = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        [_buttonGood setImage:[UIImage imageNamed:@"视频赞.png"] forState:UIControlStateNormal];
        [_buttonGood setImage:[UIImage imageNamed:@"视频赞高亮.png"] forState:UIControlStateHighlighted];
        [_buttonGood addTarget:self action:@selector(_buttonDidPush:) forControlEvents:UIControlEventTouchUpInside];
        _buttonGood.tag = 53;
        _buttonGood.alpha = 0.0;
        [self addSubview:_buttonGood];
        
        _buttonComment = [[UIButton alloc] initWithFrame:CGRectMake(10, 90, 20, 20)];
        [_buttonComment setImage:[UIImage imageNamed:@"视频评论.png"] forState:UIControlStateNormal];
        [_buttonComment setImage:[UIImage imageNamed:@"视频评论高亮.png"] forState:UIControlStateHighlighted];
        [_buttonComment addTarget:self action:@selector(_buttonDidPush:) forControlEvents:UIControlEventTouchUpInside];
        _buttonComment.tag = 54;
        _buttonComment.alpha = 0.0;
        [self addSubview:_buttonComment];
        
        _isHidden = YES;
        
        __block CGFloat x = 0.0;
        [imageName enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 40, 40, 40)];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",obj]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@高亮.png",obj]] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(_buttonDidPush:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = idx+50;
            [self addSubview:button];
            x += 75;
        }];
    }
    return self;
}

#pragma mark - Private

- (void)_buttonDidPush:(UIButton *)button
{
    NSInteger tag = button.tag-50;
    switch (tag) {
        case 0:
            {
                [UIView animateWithDuration:0.3 animations:^(void){
                    if (_isHidden) {
                        _buttonGood.alpha = 1.0;
                        _buttonComment.alpha = 1.0;
                    }
                    else {
                        _buttonGood.alpha = 0.0;
                        _buttonComment.alpha = 0.0;
                    }
                }];
                _isHidden = !_isHidden;
                break;
            }
        case 1:
            if ([self.delegate respondsToSelector:@selector(videoDelete)]) {
                [self.delegate videoDelete];
            }
            break;
        case 2:
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

@end
