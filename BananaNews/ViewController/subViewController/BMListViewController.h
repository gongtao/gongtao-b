//
//  BMListViewController.h
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "GTTableViewController.h"

#import "BMNewsListCell.h"

@interface BMListViewController : GTTableViewController

@property (nonatomic, assign) BMNewsListCellType type;

@end
