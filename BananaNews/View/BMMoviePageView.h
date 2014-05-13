//
//  BMMoviePageView.h
//  BananaNews
//
//  Created by 龚 涛 on 14-4-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMMoviePageViewDelegate <NSObject>

- (void)moviePageDidChange:(NSUInteger)page pageCount:(NSUInteger)count;

- (void)moviePageDidBeginRefresh;

@end

@interface BMMoviePageView : UIView <UIScrollViewDelegate, NSFetchedResultsControllerDelegate>
{
    UIScrollView *_scrollView;
    
    NSMutableArray *_movieItems;
}

@property (nonatomic, readonly) NSInteger currentPage;

@property (nonatomic, strong) NewsCategory *category;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) id<BMMoviePageViewDelegate> delegate;

- (News *)currentNews;

- (void)refresh;

- (void)finishPageViewRefresh:(BOOL)success;

@end
