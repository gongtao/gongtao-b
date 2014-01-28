//
//  BMUserButton.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMUserButton : UIButton
{
    CGRect _titleRect;
}

@property (nonatomic, strong) User *user;

@end
