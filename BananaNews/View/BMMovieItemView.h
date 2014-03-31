//
//  SBMovieItemView.h
//  BananaNews
//
//  Created by 龚涛 on 3/24/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BMMovieItemStatusNone,
    BMMovieItemStatusNormal,
    BMMovieItemStatusDownloading,
    BMMovieItemStatusDownloaded
}BMMovieItemStatus;

@protocol BMMovieItemViewDelegate;

@class BMCustomButton;

@interface BMMovieItemView : UIView <NSFetchedResultsControllerDelegate>
{
    UIImageView *_bgImageView;
    UIImageView *_frameImageView;
    UIImageView *_contentImageView;
    BMCustomButton *_button;
    UILabel *_titleLabel;
}

@property (nonatomic, strong) News *news;

@property (nonatomic, strong) Media *videoMedia;

@property (nonatomic, strong) Media *imageMedia;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) BMMovieItemStatus status;

@property (nonatomic, assign) id<BMMovieItemViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame tag:(NSInteger)tag delegate:(id<BMMovieItemViewDelegate>)delegate;

- (void)deleteNews;

- (void)updateNetworking:(AFNetworkReachabilityStatus)status;

@end

@protocol BMMovieItemViewDelegate <NSObject>

- (void)didUpdateDataMovieItemView:(BMMovieItemView *)itemView;

@end
