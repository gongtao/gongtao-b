//
//  BMUserButton.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMUserButton.h"

#import <UIButton+WebCache.h>

@implementation BMUserButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.font = Font_NewsSmall;
        [self setTitleColor:Color_CommentUser forState:UIControlStateNormal];
        
        _titleRect = CGRectZero;
    }
    return self;
}

- (void)setUser:(User *)user
{
    if (!user) {
        _user = nil;
    }
    if (_user.uid.integerValue != user.uid.integerValue) {
        _user = user;
        __block BMUserButton *weakSelf = self;
        [self setImageWithURL:[NSURL URLWithString:user.avatar]
                     forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                         [weakSelf setImage:image
                                   forState:UIControlStateHighlighted];
                     }];
        [self setTitle:_user.name forState:UIControlStateNormal];
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    CGSize size = CGSizeZero;
    if (title && title.length>0) {
        size = [title sizeWithFont:Font_NewsSmall];
        if (size.width > 54.0) {
            size.width = 54.0;
        }
    }
    _titleRect = CGRectMake((self.frame.size.width-size.width)/2.0, 49.0, size.width, 14.0);
    [super setTitle:title forState:state];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(13.0, 10.0, 32.0, 32.0);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return _titleRect;
}

@end
