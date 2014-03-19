//
//  BMToolBar.h
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMToolBarDelegate <NSObject>

- (void)didSelectTagAtIndex:(NSUInteger)index;

@end

@interface BMToolBar : UIView
{
    NSUInteger _lastIndex;
    
    NSArray *_titleArray;
}

@property (nonatomic, weak) id<BMToolBarDelegate> delegate;

- (void)selectedTagAtIndex:(NSUInteger)index;

@end
