//
//  BMUserSearchView.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMUserSearchView.h"

#import "BMUserButton.h"

@interface BMUserButton ()

- (void)_userButtonPressed:(BMUserButton *)button;

@end

@implementation BMUserSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(6.0, 6.0, 308.0, 96.0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderWidth = 1.0;
        _contentView.layer.borderColor = Color_GrayLine.CGColor;
        _contentView.layer.cornerRadius = 2.0;
        [self addSubview:_contentView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0, 0.0, 200.0, 24.0)];
        _textLabel.font = Font_NewsTitle;
        _textLabel.textColor = Color_NewsFont;
        _textLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_textLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(287.0, 4.0, 15.0, 15.0)];
        imageView.image = [UIImage imageNamed:@"左侧Cell箭头选中.png"];
        [_contentView addSubview:imageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(2.0, 24.0, 304.0, 1.0)];
        lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"虚线.png"]];
        [_contentView addSubview:lineView];
        
        _usersView = [[UIView alloc] initWithFrame:CGRectMake(9.0, 24.0, 290.0, 70.0)];
        _usersView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_usersView];
    }
    return self;
}

- (void)setUsers:(NSArray *)users
{
    if (_users != users) {
        _users = users;
        [_usersView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop){
            [obj removeFromSuperview];
        }];
        if (_users && _users.count>0) {
            _textLabel.text = [NSString stringWithFormat:@"相关用户（%i）", users.count];
            __block CGFloat x = 0.0;
            [_users enumerateObjectsUsingBlock:^(User *user, NSUInteger idx, BOOL *stop){
                BMUserButton *button = [[BMUserButton alloc] initWithFrame:CGRectMake(x, 0.0, 58.0, 70.0)];
                button.user = user;
                [button addTarget:self action:@selector(_userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [_usersView addSubview:button];
                x += 58.0;
                if (idx >= 4) {
                    *stop = YES;
                }
            }];
        }
    }
}

- (void)_userButtonPressed:(BMUserButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didSelectUser:)]) {
        [self.delegate didSelectUser:button.user];
    }
}

@end
