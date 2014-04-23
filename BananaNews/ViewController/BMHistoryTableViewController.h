//
//  BMHistoryTableViewController.h
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-23.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "GTTableViewController.h"

#import "BMHistoryTableViewCell.h"

@interface BMHistoryTableViewController : GTTableViewController<BMHistoryTableViewCellDelegate>

- (id)initWithRequest:(NSFetchRequest *)request cacheName:(NSString *)cache;

@end
