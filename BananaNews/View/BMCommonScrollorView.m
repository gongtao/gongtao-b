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
        //_scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(50, 0, 250, self.bounds.size.height)];
        _scrollView.delegate=self;
        [self setTotalPages];
        //_scrollView.contentSize=CGSizeMake(self.bounds.size.width*_totalPages, self.bounds.size.height);
        _scrollView.contentSize=CGSizeMake(250*_totalPages, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator=NO;
        //_offset=210;
        _scrollView.contentOffset=CGPointMake(250, 0);
        //_scrollView.contentOffset=CGPointMake(_offset, 0);
        _scrollView.pagingEnabled=YES;
        _scrollView.clipsToBounds=NO;
        [self addSubview:_scrollView];
        
        _currentPage=_totalPages/2;
        
    }
    return self;
}

-(void)setTotalPages
{
    _totalPages=3;
}

-(void)setDataSource:(id<BMCommonScrollorViewDataSource>)dataSource
{
    _dataSource=dataSource;
    [self loadData];
}

-(void)loadData
{
    for (int i=0; i<_totalPages; i++) {
        CGRect rect=self.bounds;
        //rect.origin.x=40;
        rect.size.width=210;
        UIView *view=[_dataSource pageAtIndex:i withFrame:rect];
        view.frame=CGRectOffset(view.frame, (view.frame.size.width+20)*i, 0);
        [_scrollView addSubview:view];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x=scrollView.contentOffset.x;
    //往下翻
    if (x>=(2*self.frame.size.width)) {
        //_currentPage=[_delegate validPageValue:_currentPage+1];
        _currentPage=_currentPage+1;
        if (_currentPage>_totalPages-1) {
            _currentPage=_totalPages-1;
        }
        //_currentPage=1;
    }
    //往上翻
    else if(x<0)
    {
        //_currentPage=[_delegate validPageValue:_currentPage-1];
        _currentPage=_currentPage-1;
        if (_currentPage<0) {
            _currentPage=0;
        }
        //_currentPage=0;
    }
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
