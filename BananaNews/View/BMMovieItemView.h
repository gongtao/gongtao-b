//
//  SBMovieItemView.h
//  BananaNews
//
//  Created by 龚涛 on 3/24/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMMovieItemView : UIView
{
    UIImageView *_bgImageView;
    UIImageView *_frameImageView;
    UIImageView *_contentImageView;
}

@property (nonatomic, strong) News *news;

@end
