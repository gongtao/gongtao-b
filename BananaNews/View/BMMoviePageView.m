//
//  BMMoviePageView.m
//  BananaNews
//
//  Created by 龚 涛 on 14-4-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMMoviePageView.h"

#import "BMSubMovieItemView.h"

@interface BMMoviePageView ()

@property (nonatomic, strong) UIButton *refreshButton;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (NSManagedObjectContext *)managedObjectContext;

- (NSFetchRequest *)fetchRequest;

- (void)performFetch;

- (void)_updatePage;

- (void)_reloadData;

- (void)_refreshButtonPressed:(UIButton *)button;

@end

@implementation BMMoviePageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _currentPage = 0;
        
        frame.origin = CGPointZero;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _movieItems = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

#pragma mark - Public

- (News *)currentNews
{
    if ([[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]>_currentPage) {
        return [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
    }
    return nil;
}

- (void)refresh
{
    [self _refreshButtonPressed:nil];
}

- (void)finishPageViewRefresh:(BOOL)success
{
    if (_indicatorView) {
        [_indicatorView stopAnimating];
        _indicatorView.hidden = YES;
    }
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (!success && 0==count) {
        _refreshButton.hidden = NO;
    }
}

#pragma mark - Private

- (void)_updatePage
{
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    int index = (_scrollView.contentOffset.x+10.0)/_scrollView.frame.size.width;
    if (count <= 3) {
        _currentPage = index;
    }
    else if (index==0 && _currentPage<=1) {
        _currentPage = 0;
    }
    else if (index==1 && _currentPage==0) {
        _currentPage = 1;
    }
    else if (index==2 && _currentPage>=count-2) {
        _currentPage = count-1;
        if (count > 10) {
            [[BMNewsManager sharedManager] getDownloadList:self.category.category_id page:(count/10+1) success:nil failure:nil];
        }
    }
    else if (index==1 && _currentPage==count-1) {
        _currentPage = count-2;
    }
    else {
        if (index == 0) {
            BMSubMovieItemView *item = (BMSubMovieItemView *)[_movieItems objectAtIndex:2];
            [_movieItems removeObject:item];
            [_movieItems insertObject:item atIndex:0];
            _currentPage--;
            item.news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:_currentPage-1 inSection:0]];
        }
        else if (index == 2) {
            BMSubMovieItemView *item = (BMSubMovieItemView *)[_movieItems objectAtIndex:0];
            [_movieItems removeObject:item];
            [_movieItems addObject:item];
            _currentPage++;
            item.news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:_currentPage+1 inSection:0]];
        }
        else {
            return;
        }
        [_movieItems enumerateObjectsUsingBlock:^(BMSubMovieItemView *obj, NSUInteger idx, BOOL *stop){
            obj.frame = CGRectMake(45.0+self.frame.size.width*idx, 0.0, 230.0, self.frame.size.height);
        }];
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0.0);
    }
    if ([self.delegate respondsToSelector:@selector(moviePageDidChange:pageCount:)]) {
        [self.delegate moviePageDidChange:_currentPage pageCount:count];
    }
}

- (void)_reloadData
{
    if (_refreshButton) {
        _refreshButton.hidden = YES;
    }
    [_movieItems enumerateObjectsUsingBlock:^(BMSubMovieItemView *obj, NSUInteger idx, BOOL *stop){
        obj.news = nil;
        [obj removeFromSuperview];
    }];
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    if (count == 0) {
        _currentPage = 0;
        if (!_refreshButton) {
            _refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(45.0, 0.0, 230.0, self.frame.size.height)];
            [_refreshButton setTitle:@"网络不给力，点击重新加载" forState:UIControlStateNormal];
            [_refreshButton setTitleColor:Color_NewsSmallFont forState:UIControlStateNormal];
            [_refreshButton addTarget:self action:@selector(_refreshButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:_refreshButton];
        }
        _refreshButton.hidden = NO;
        
//        if (_movieItems.count == 0) {
//            BMSubMovieItemView *item = [[BMSubMovieItemView alloc] initWithFrame:CGRectMake(45.0, 0.0, 230.0, self.frame.size.height)];
//            [_movieItems addObject:item];
//        }
//        BMSubMovieItemView *item = (BMSubMovieItemView *)[_movieItems objectAtIndex:0];
//        item.frame = CGRectMake(45.0, 0.0, 230.0, self.frame.size.height);
//        [_scrollView addSubview:item];
        
        _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _scrollView.contentOffset = CGPointMake(0.0, 0.0);
    }
    else {
        int num = _movieItems.count;
        if (count < 3) {
            if (num < count) {
                for (int i = count-num; i>0; i--) {
                    BMSubMovieItemView *item = [[BMSubMovieItemView alloc] initWithFrame:CGRectMake(45.0, 0.0, 230.0, self.frame.size.height)];
                    [_movieItems addObject:item];
                }
            }
            _scrollView.contentSize = CGSizeMake(count*self.frame.size.width, self.frame.size.height);
            if (_currentPage > count-1) {
                _currentPage = 0;
            }
            _scrollView.contentOffset = CGPointMake(_currentPage*self.frame.size.width, 0.0);
            [_movieItems enumerateObjectsUsingBlock:^(BMSubMovieItemView *obj, NSUInteger idx, BOOL *stop){
                obj.frame = CGRectMake(45.0+self.frame.size.width*idx, 0.0, 230.0, self.frame.size.height);
                obj.news = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                [_scrollView addSubview:obj];
                if (idx == count-1) {
                    *stop = YES;
                }
            }];
        }
        else {
            if (num < 3) {
                for (int i = 3-num; i>0; i--) {
                    BMSubMovieItemView *item = [[BMSubMovieItemView alloc] initWithFrame:CGRectMake(45.0, 0.0, 230.0, self.frame.size.height)];
                    [_movieItems addObject:item];
                }
            }
            _scrollView.contentSize = CGSizeMake(3*self.frame.size.width, self.frame.size.height);
            if (_currentPage > count-1) {
                _currentPage = 0;
            }
            int index = 0;
            if (_currentPage == 0) {
                index = 0;
                _scrollView.contentOffset = CGPointZero;
            }
            else if (_currentPage == count-1){
                index = count-3;
                _scrollView.contentOffset = CGPointMake(2*self.frame.size.width, 0.0);
            }
            else {
                index = _currentPage-1;
                _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0.0);
            }
            [_movieItems enumerateObjectsUsingBlock:^(BMSubMovieItemView *obj, NSUInteger idx, BOOL *stop){
                obj.frame = CGRectMake(45.0+self.frame.size.width*idx, 0.0, 230.0, self.frame.size.height);
                obj.news = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index+idx inSection:0]];
                [_scrollView addSubview:obj];
            }];
        }
    }
    if ([self.delegate respondsToSelector:@selector(moviePageDidChange:pageCount:)]) {
        [self.delegate moviePageDidChange:_currentPage pageCount:count];
    }
}

- (void)_refreshButtonPressed:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(moviePageDidBeginRefresh)]) {
        if (!_indicatorView) {
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _indicatorView.center = CGPointMake(160.0, self.frame.size.height/2.0);
            _indicatorView.hidden = YES;
            [_scrollView addSubview:_indicatorView];
        }
        if (0 == [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]) {
            [_indicatorView startAnimating];
            _indicatorView.hidden = NO;
        }
        if (_refreshButton) {
            _refreshButton.hidden = YES;
        }
        [self.delegate moviePageDidBeginRefresh];
    }
}

#pragma mark - Property

- (void)setCategory:(NewsCategory *)category
{
    if (_category != category) {
        _category = category;
        [self _reloadData];
    }
}

#pragma mark - DataBase method

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    [self performFetch];
    
    return _fetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    id appDelegate = [UIApplication sharedApplication].delegate;
    return [appDelegate managedObjectContext];
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY category.category_id == %@", _category.category_id];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO]]];
    return request;
}

- (void)performFetch
{
    if (!_fetchedResultsController) {
        [self fetchedResultsController];
        return;
    }
    
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self _reloadData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _updatePage];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self _updatePage];
    }
}

@end
