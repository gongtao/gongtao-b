//
//  BMLeftViewController.h
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMSearchView.h"

@interface BMLeftViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _lastSelectedRow;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *controllerTitleArray;

@property (nonatomic, strong) NSMutableDictionary *controllerDic;

- (void)selectVCAtIndex:(NSUInteger)row;

- (void)deselectVC;

@end
