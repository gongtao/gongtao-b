//
//  BMCommentTableViewController.h
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-30.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "GTTableViewController.h"

#import "EGORefreshTableHeaderView.h"

#import "BMVideoCommentCell.h"

@protocol BMCommentTableViewControllerDelegate <NSObject>

- (void)willReplyComment:(Comment *)comment;

@end

@interface BMCommentTableViewController : GTTableViewController<EGORefreshTableHeaderDelegate, UIAlertViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
    
    NSInteger _postId;

}

//@property (nonatomic, strong) NSString *categoryId;

//@property (nonatomic, assign) BMNewsListCellType type;

@property (nonatomic,assign) News *news;

@property (nonatomic,assign) id<BMCommentTableViewControllerDelegate> delegate;

- (id)initWithRequest:(NSFetchRequest *)request cacheName:(NSString *)cache;

- (void)refreshLastUpdateTime;

- (void)startLoadingTableViewData;

- (void)doneLoadingTableViewData;

@end
