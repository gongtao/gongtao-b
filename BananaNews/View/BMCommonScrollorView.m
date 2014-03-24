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
        [self setPageWidth];
        int offset=(self.bounds.size.width-_pageWidth)/2;
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(offset, 0, _pageWidth, self.bounds.size.height)];
        _scrollView.delegate=self;
        [self setTotalPages];
        _scrollView.contentSize=CGSizeMake(_pageWidth*_totalPages, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator=NO;
        //_scrollView.contentOffset=CGPointMake(_pageWidth, 0);
        _scrollView.pagingEnabled=YES;
        _scrollView.clipsToBounds=NO;
        [self addSubview:_scrollView];
        _currentOffset=0;
        
        _curViews = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)setTotalPages
{
    _totalPages=3;
}

-(void)setPageWidth
{
    _pageWidth=230;
}

-(void)setDataSource:(id<BMCommonScrollorViewDataSource>)dataSource
{
    _dataSource=dataSource;
    [self loadData];
    _currentPage=0;
    //_prePage=_currentPage;
    UIView *view=[_curViews objectAtIndex:_currentPage];
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.3);//CGAffineTransformMakeScale(1.2f,1.2f);
    

}

-(void)loadData
{
    for (int i=0; i<_totalPages; i++) {
        CGRect rect=self.bounds;
        rect.origin.x=10;
        rect.size.width=210;
        UIView *view=[_dataSource pageAtIndex:i withFrame:rect];
        view.frame=CGRectOffset(view.frame, (view.frame.size.width+20)*i, 0);
        [_scrollView addSubview:view];
        [_curViews addObject:view];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float x=_scrollView.contentOffset.x;
    if (x>_currentOffset) {
        //往左边滑动
        int page=x/_pageWidth;
        UIView *view=[_curViews objectAtIndex:page];
        int x1=(int)x%_pageWidth;
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0+0.3*(1-((float)x1/_pageWidth)));
        if (page+1<_totalPages) {
            UIView *preView=[_curViews objectAtIndex:page+1];
            preView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0+0.3*(float)x1/_pageWidth);
            
        }
         _currentOffset=x;


        /*if (x<2*_pageWidth) {
            <#statements#>
        }*/
    }
    else if (x<_currentOffset)
    {//往右滑动
       /* if (x>0) {
            statements
        }*/
        int page=x/_pageWidth;
        int x1=_pageWidth-(int)x%_pageWidth;
        if (page+1<_totalPages) {
            UIView *view=[_curViews objectAtIndex:page+1];
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0+0.3*(1-((float)x1/_pageWidth)));
        }
        UIView *preView=[_curViews objectAtIndex:page];
        preView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0+0.3*(float)x1/_pageWidth);
        _currentOffset=x;
        
    }
    
    
 /*   int page=x/_pageWidth;
    UIView *view=[_curViews objectAtIndex:page];
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0+0.3*(float)((int)x%(int)_pageWidth)/_pageWidth);
    
    UIView *preView=[_curViews objectAtIndex:_currentPage];
    preView.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0+0.3*(float)((int)x%(int)_pageWidth)/_pageWidth);
    _currentPage=page;*/
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[_scrollView setContentOffset:CGPointMake(num*_scrollView.frame.size.width, 0) animated:YES];
    /*int x=_scrollView.contentOffset.x;
    if (_currentPage) {
        [_scrollView setContentOffset:CGPointMake(x+_offset, 0) animated:YES];
  
    }
    else
    {
        [_scrollView setContentOffset:CGPointMake(x-_offset, 0) animated:YES];
    }
     */
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
