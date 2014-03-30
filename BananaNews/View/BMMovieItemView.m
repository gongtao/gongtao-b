//
//  SBMovieItemView.m
//  BananaNews
//
//  Created by 龚涛 on 3/24/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMMovieItemView.h"

@implementation BMMovieItemView

- (id)initWithFrame:(CGRect)frame tag:(NSInteger)tag delegate:(id<BMMovieItemViewDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.tag = tag;
        _delegate = delegate;
        _title = @"WIFI时自动下载视频，不费流量";
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_bgImageView setImage:[UIImage imageNamed:@"视频框背景.png"]];
        _bgImageView.contentMode = UIViewContentModeCenter;
        _bgImageView.clipsToBounds = YES;
        [self addSubview:_bgImageView];
        
        CGRect frame = self.bounds;
        frame.size.height = 156.0;
        _contentImageView = [[UIImageView alloc] initWithFrame:frame];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
        [self addSubview:_contentImageView];
        
        _frameImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_frameImageView setImage:[UIImage imageNamed:@"视频框.png"]];
        [self addSubview:_frameImageView];
        
        int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
        if (count != 0) {
            self.news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            if ([_delegate respondsToSelector:@selector(didUpdateDataMovieItemView:)]) {
                [_delegate didUpdateDataMovieItemView:self];
            }
        }
    }
    return self;
}

- (void)setNews:(News *)news
{
    if (_news != news) {
        _news = news;
        self.videoMedia = nil;
        self.imageMedia = nil;
        if (!_news) {
            _title = @"WIFI时自动下载视频，不费流量";
            return;
        }
        _title = news.title;
        [_news.medias enumerateObjectsUsingBlock:^(Media *obj, NSUInteger idx, BOOL *stop){
            if (!self.videoMedia && ([obj.type rangeOfString:@"image"].location == NSNotFound)) {
                self.videoMedia = obj;
            }
            else if (!self.imageMedia) {
                self.imageMedia = obj;
            }
            else {
                *stop = YES;
            }
        }];
    }
}

- (void)setVideoMedia:(Media *)videoMedia
{
    if (_videoMedia != videoMedia) {
        _videoMedia = videoMedia;
        if (!_videoMedia) {
            return;
        }
    }
}

- (void)setImageMedia:(Media *)imageMedia
{
    if (_imageMedia != imageMedia) {
        _imageMedia = imageMedia;
        if (!_imageMedia) {
            _contentImageView.image = nil;
            return;
        }
        [_contentImageView setImageWithURL:[NSURL URLWithString:self.imageMedia.large] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        }];
    }
}

#pragma mark - DataBase method

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:[NSString stringWithFormat:@"Recommend%i", self.tag]];
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
    request.predicate = [NSPredicate predicateWithFormat:@"(ANY category.isHead == %@) AND (%K == %@)", [NSNumber numberWithBool:YES], kStatus, [NSNumber numberWithInt:self.tag]];
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
    int count = [[[controller sections] objectAtIndex:0] numberOfObjects];
    if (count == 0) {
        self.news = nil;
    }
    else {
        self.news = [controller objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    if ([_delegate respondsToSelector:@selector(didUpdateDataMovieItemView:)]) {
        [_delegate didUpdateDataMovieItemView:self];
    }
}

@end
