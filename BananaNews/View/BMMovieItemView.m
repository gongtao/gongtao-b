//
//  SBMovieItemView.m
//  BananaNews
//
//  Created by 龚涛 on 3/24/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMMovieItemView.h"

#import "BMCustomButton.h"

#import <MediaPlayer/MediaPlayer.h>

@interface BMMovieItemView ()

@property (nonatomic, strong) AFDownloadRequestOperation *request;

- (NSString *)_getVideoFilePath;

- (void)_downloadVideo;

- (void)_buttonPressed:(UIButton *)button;

@end

@implementation BMMovieItemView

- (id)initWithFrame:(CGRect)frame tag:(NSInteger)tag delegate:(id<BMMovieItemViewDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.tag = tag;
        _delegate = delegate;
        _status = BMMovieItemStatusNone;
        
        CGRect frame = self.bounds;
        frame.size.height = 180.0;
        _bgImageView = [[UIImageView alloc] initWithFrame:frame];
        [_bgImageView setImage:[UIImage imageNamed:@"视频框背景.png"]];
        _bgImageView.contentMode = UIViewContentModeCenter;
        _bgImageView.clipsToBounds = YES;
        [self addSubview:_bgImageView];
        
        frame.size.height = 156.0;
        _contentImageView = [[UIImageView alloc] initWithFrame:frame];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
        [self addSubview:_contentImageView];
        
        frame.size.height = 180.0;
        _frameImageView = [[UIImageView alloc] initWithFrame:frame];
        [_frameImageView setImage:[UIImage imageNamed:@"视频框.png"]];
        [self addSubview:_frameImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 175.0, 204.0, 45.0)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"WIFI时自动下载视频，不费流量";
        [self addSubview:_titleLabel];
        
        _button = [[BMCustomButton alloc] initWithFrame:frame];
        [_button setImageRect:CGRectMake(self.bounds.size.width/2.0-20.0, 58.0, 40.0, 40.0)];
        [_button addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNews:(News *)news
{
    if (_news != news) {
        _news = news;
        self.videoMedia = nil;
        self.imageMedia = nil;
        if (!_news) {
            _titleLabel.text = @"WIFI时自动下载视频，不费流量";
            self.status = BMMovieItemStatusNone;
            return;
        }
        _titleLabel.text = news.title;
        self.status = BMMovieItemStatusNormal;
        [_news.medias enumerateObjectsUsingBlock:^(Media *obj, NSUInteger idx, BOOL *stop){
            if ([obj.type rangeOfString:@"image"].location == NSNotFound) {
                if (!self.videoMedia) {
                    self.videoMedia = obj;
                }
            }
            else if (!self.imageMedia) {
                self.imageMedia = obj;
            }
            if (self.imageMedia && self.videoMedia) {
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
        [self _downloadVideo];
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

- (void)setStatus:(BMMovieItemStatus)status
{
    if (_status == status) {
        return;
    }
    _status = status;
    switch (_status) {
        case BMMovieItemStatusNone: {
            [_frameImageView setImage:[UIImage imageNamed:@"视频框.png"]];
            [_button setImage:nil forState:UIControlStateNormal];
            [_button setImage:nil forState:UIControlStateHighlighted];
            break;
        }
        case BMMovieItemStatusNormal:
        case BMMovieItemStatusDownloaded: {
            [_frameImageView setImage:[UIImage imageNamed:@"视频框.png"]];
            [_button setImage:[UIImage imageNamed:@"视频框播放.png"] forState:UIControlStateNormal];
            [_button setImage:[UIImage imageNamed:@"视频框播放高亮.png"] forState:UIControlStateHighlighted];
            break;
        }
        case BMMovieItemStatusDownloading: {
            [_frameImageView setImage:[UIImage imageNamed:@"视频框下载.png"]];
            [_button setImage:nil forState:UIControlStateNormal];
            [_button setImage:nil forState:UIControlStateHighlighted];
            break;
        }
        default:
            break;
    }
}

- (void)deleteNews
{
    self.news.status = [NSNumber numberWithInteger:-1];
    [[BMNewsManager sharedManager] saveContext];
}

- (void)updateNetworking:(AFNetworkReachabilityStatus)status
{
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            if (_request) {
                [_request pause];
                _request = nil;
                self.status = BMMovieItemStatusNormal;
            }
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            [self _downloadVideo];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private

- (NSString *)_getVideoFilePath
{
    if (_videoMedia) {
        return [[AFDownloadRequestOperation cacheFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", _videoMedia.url]];
    }
    else {
        return nil;
    }
}

- (void)_downloadVideo
{
    if (!_videoMedia) {
        return;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self _getVideoFilePath]]) {
        self.status = BMMovieItemStatusDownloaded;
        return;
    }
    if (![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
        return;
    }
    if (_request) {
        return;
    }
    self.status = BMMovieItemStatusDownloading;
    [[BMNewsManager sharedManager] getDownloadVideoUrl:_videoMedia.url success:^(NSString *url){
        _request = [[BMNewsManager sharedManager] getDownloadVideo:_videoMedia.url url:url success:^(void){
            NSString *url = [AFDownloadRequestOperation cacheFolder];
            [[NSFileManager defaultManager] moveItemAtPath:[url stringByAppendingPathComponent:_videoMedia.url] toPath:[url stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", _videoMedia.url]] error:nil];
            _request = nil;
            self.status = BMMovieItemStatusDownloaded;
        } failure:^(NSError *error){
            _request = nil;
            self.status = BMMovieItemStatusNormal;
        }];
    } failure:nil];
}

- (void)_playVideo
{
    NSString *path = [self _getVideoFilePath];
    NSURL *url = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        self.status = BMMovieItemStatusDownloaded;
        url = [NSURL fileURLWithPath:path];
    }
    else {
        path = [NSString stringWithFormat:@"http://v.youku.com/player/getRealM3U8/vid/%@/type/mp4/v.m3u8", _videoMedia.url];
        url = [NSURL URLWithString:path];
    }
    if (url) {
        NSDate *date = [NSDate new];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.news.history_day = [formatter stringFromDate:date];
        [[BMNewsManager sharedManager] saveContext];
        
        MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC presentMoviePlayerViewControllerAnimated:vc];
    }
}

- (void)_buttonPressed:(UIButton *)button
{
    switch (_status) {
        case BMMovieItemStatusNormal:
        case BMMovieItemStatusDownloaded: {
            [self _playVideo];
            break;
        }
        case BMMovieItemStatusDownloading: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"视频" message:@"亲~视频还没下载好，请耐心等待哦~" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alertView show];
            break;
        }
        default:
            break;
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
