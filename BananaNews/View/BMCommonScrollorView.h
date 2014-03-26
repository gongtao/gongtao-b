//
//  BMCommonScrollorView.h
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-21.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BMCommonScrollorViewDelegate <NSObject>

@optional

- (void)commonScrollorViewDidSelectPage:(NSUInteger)index;

//- (NSInteger)validPageValue:(NSInteger)value;

@end

@protocol BMCommonScrollorViewDataSource <NSObject>

@required

-(UIView *)pageAtIndex:(NSInteger)index withFrame:(CGRect)frame;

@end

@interface BMCommonScrollorView : UIView<UIScrollViewDelegate>
{
    NSInteger _totalPages;
    NSInteger _pageWidth;
    float _currentOffset;
    NSMutableArray *_curViews;
}


@property (nonatomic, weak) id<BMCommonScrollorViewDelegate> delegate;

@property (nonatomic, strong, setter=setDataSource:) id<BMCommonScrollorViewDataSource> dataSource;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign, readonly) NSUInteger currentPage;

- (UIView *)viewForPage:(NSUInteger)page;

- (UIView *)currentSelectedView;

@end