//
//  BMToolBar.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMToolBar.h"

#import "BMCustomButton.h"

@interface BMToolBar ()

- (void)_buttonSelected:(UIButton *)button;

@end

@implementation BMToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 1.0)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:lineView];
        
        _titleArray = @[@"推荐", @"分类", @"我的", @"设置"];
        __block CGFloat x = 0.0;
        [_titleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            BMCustomButton *button = [[BMCustomButton alloc] initWithFrame:CGRectMake(x, 0.0, 80.0, frame.size.height)];
            button.imageRect = CGRectMake(30.0, 8.0, 20.0, 20.0);
            button.titleRect = CGRectMake(28.0, 28.0, 24.0, 18.0);
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            [button setTitleColor:Color_NavBarBg forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"工具栏%@.png", obj]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"工具栏%@高亮.png", obj]] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(_buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100+idx;
            [self addSubview:button];
            x += 80.0;
        }];
        _lastIndex = -1;
    }
    return self;
}

#pragma mark - Private

- (void)_buttonSelected:(UIButton *)button
{
    [self selectedTagAtIndex:button.tag-100];
}

#pragma mark - Public

- (void)selectedTagAtIndex:(NSUInteger)index
{
    if (_lastIndex!=-1) {
        UIButton *lastButton = (UIButton *)[self viewWithTag:_lastIndex+100];
        NSString *title = _titleArray[_lastIndex];
        [lastButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [lastButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"工具栏%@.png", title]] forState:UIControlStateNormal];
        [lastButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"工具栏%@高亮.png", title]] forState:UIControlStateHighlighted];
    }
    if (index!=_lastIndex) {
        UIButton *button = (UIButton *)[self viewWithTag:index+100];
        NSString *title = _titleArray[index];
        [button setTitleColor:Color_NavBarBg forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"工具栏%@高亮.png", title]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"工具栏%@高亮.png", title]] forState:UIControlStateHighlighted];
        if ([self.delegate respondsToSelector:@selector(didSelectTagAtIndex:)]) {
            [self.delegate didSelectTagAtIndex:index];
        }
    }
    _lastIndex = index;
}

@end
