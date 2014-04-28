//
//  BMSubMovieItemView.h
//  BananaNews
//
//  Created by 龚 涛 on 14-4-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMCustomButton;

@interface BMSubMovieItemView : UIView
{
    UIImageView *_bgImageView;
    UIImageView *_frameImageView;
    UIImageView *_contentImageView;
    BMCustomButton *_button;
    UILabel *_titleLabel;
}

@property (nonatomic, strong) News *news;

@property (nonatomic, strong) Media *videoMedia;

@property (nonatomic, strong) Media *imageMedia;

@end
