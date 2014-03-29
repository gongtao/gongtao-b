//
//  BMCommonScrollorView.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-21.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMCommonScrollorView.h"

@implementation BMCommonScrollorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString *key = @"dataBaseRecommendNewsIndex";
        NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (!index) {
            index = [NSNumber numberWithInteger:0];
            [[NSUserDefaults standardUserDefaults] setObject:index forKey:key];
        }
        _newsIndex = index.integerValue;
        
        [self setPageWidth];
        int offset=(self.bounds.size.width-_pageWidth)/2;
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(offset, 0, _pageWidth, self.bounds.size.height)];
        _scrollView.delegate=self;
        [self setTotalPages];
        _scrollView.contentSize=CGSizeMake(_pageWidth*_totalPages, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.pagingEnabled=YES;
        _scrollView.clipsToBounds=NO;
        [self addSubview:_scrollView];
        _currentOffset=0;
        
        _curViews = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)setTotalPages
{
    _totalPages=3;
}

- (void)setPageWidth
{
    _pageWidth=230;
}

- (void)setDataSource:(id<BMCommonScrollorViewDataSource>)dataSource
{
    _dataSource=dataSource;
    [self loadData];
    _currentPage=0;
    UIView *view=[_curViews objectAtIndex:_currentPage];
    view.transform = CGAffineTransformIdentity;
}

- (void)loadData
{
    for (int i=0; i<_totalPages; i++) {
        CGRect rect=self.bounds;
        rect.origin.x=10;
        rect.size.width=210;
        UIView *view=[_dataSource pageAtIndex:i withFrame:rect];
        view.frame=CGRectOffset(view.frame, (view.frame.size.width+20)*i, 0);
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        [_scrollView addSubview:view];
        [_curViews addObject:view];
    }
}

- (void)updatePage
{
    int page = (int)(_scrollView.contentOffset.x+10.0)/_scrollView.frame.size.width;
    if (page != _currentPage) {
        _currentPage = page;
        if ([self.delegate respondsToSelector:@selector(commonScrollorViewDidSelectPage:)]) {
            [self.delegate commonScrollorViewDidSelectPage:_currentPage];
        }
    }
}

#pragma mark - Public

- (BMMovieItemView *)viewForPage:(NSUInteger)page
{
    return [_curViews objectAtIndex:page];
}

- (BMMovieItemView *)currentSelectedView
{
    return [_curViews objectAtIndex:_currentPage];
}

- (void)updateSubViewData:(NSFetchedResultsController *)fetchedResultsController
{
    int count = [[[fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (count == 0) {
        return;
    }
    __block int index = 0;
    [_curViews enumerateObjectsUsingBlock:^(BMMovieItemView *obj, NSUInteger idx, BOOL *stop){
        if (!obj.news && index<count) {
            News *news = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            news.status = [NSNumber numberWithInteger:obj.tag];
            index++;
        }
    }];
    [[BMNewsManager sharedManager] saveContext];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x=_scrollView.contentOffset.x;
    CGFloat scale = 0.0;
    if (x>_currentOffset) {
        //往左边滑动
        int page=x/_pageWidth;
        UIView *view=[_curViews objectAtIndex:page];
        int x1=(int)x%_pageWidth;
        scale = 0.8+0.2*(1-((float)x1/_pageWidth));
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        if (page+1<_totalPages) {
            UIView *preView=[_curViews objectAtIndex:page+1];
            scale = 0.8+0.2*(float)x1/_pageWidth;
            preView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
            
        }
         _currentOffset=x;
    }
    else if (x<_currentOffset)
    {
        int page=x/_pageWidth;
        int x1=_pageWidth-(int)x%_pageWidth;
        if (page+1<_totalPages) {
            UIView *view=[_curViews objectAtIndex:page+1];
            scale = 0.8+0.2*(1-((float)x1/_pageWidth));
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        }
        UIView *preView=[_curViews objectAtIndex:page];
        scale = 0.8+0.2*(float)x1/_pageWidth;
        preView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        _currentOffset=x;
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePage];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePage];
    }
}

@end
