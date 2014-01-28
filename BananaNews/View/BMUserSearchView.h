//
//  BMUserSearchView.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMUserSearchViewDelegate <NSObject>

- (void)didSelectUser:(User *)user;

@end

@interface BMUserSearchView : UIView
{
    UIView *_contentView;
    
    UIView *_usersView;
    
    UILabel *_textLabel;
}

@property (nonatomic, strong) NSArray *users;

@property (nonatomic, weak) id<BMUserSearchViewDelegate> delegate;

@end
