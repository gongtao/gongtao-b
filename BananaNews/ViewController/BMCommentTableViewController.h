//
//  BMCommentTableViewController.h
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-3-30.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "GTTableViewController.h"

#import "EGORefreshTableHeaderView.h"

@interface BMCommentTableViewController : GTTableViewController<EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
    
    NSInteger _postId;

}

@property (nonatomic, strong) NSString *categoryId;

//@property (nonatomic, assign) BMNewsListCellType type;

- (id)initWithRequest:(NSFetchRequest *)request cacheName:(NSString *)cache;

- (void)refreshLastUpdateTime;

- (void)startLoadingTableViewData;

- (void)doneLoadingTableViewData;

@end
