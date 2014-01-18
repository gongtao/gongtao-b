//
//  BMListViewController.h
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "GTTableViewController.h"

#import "BMNewsListCell.h"

#import "EGORefreshTableHeaderView.h"

#import "UMSocial.h"

@interface BMListViewController : GTTableViewController <EGORefreshTableHeaderDelegate, UMSocialUIDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
    
    NSInteger _postId;
}

@property (nonatomic, assign) BMNewsListCellType type;

- (id)initWithRequest:(NSFetchRequest *)request cacheName:(NSString *)cache;

@end
