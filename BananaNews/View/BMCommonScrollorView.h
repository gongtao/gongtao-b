//
//  BMCommonScrollorView.h
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-21.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>


/*@protocol BMCommonScrollorViewDelegate <NSObject>

@optional

//-(NSInteger)validPageValue:(NSInteger)value;

@end
*/

@protocol BMCommonScrollorViewDataSource <NSObject>

@required

//-(int)numberOfPages;

-(UIView *)pageAtIndex:(NSInteger)index withFrame:(CGRect)frame;

@end

@interface BMCommonScrollorView : UIView<UIScrollViewDelegate>
{
    NSInteger _totalPages;
    NSInteger _currentPage;
    NSInteger _offset;
}


//@property (nonatomic,weak) id<BMCommonScrollorViewDelegate> delegate;

@property (nonatomic,strong,setter =setDataSource:) id<BMCommonScrollorViewDataSource> dataSource;

@property (nonatomic,strong) UIScrollView *scrollView;


@end