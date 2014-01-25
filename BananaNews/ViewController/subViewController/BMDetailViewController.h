//
//  BMDetailViewController.h
//  BananaNews
//
//  Created by 龚涛 on 1/9/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "GTTableViewController.h"

@protocol BMDetailViewControllerDelegate <NSObject>

- (void)willReplyComment:(Comment *)comment;

@end

@interface BMDetailViewController : GTTableViewController

@property (nonatomic, weak) id<BMDetailViewControllerDelegate> delegate;

- (id)initWithRequest:(News *)news;

@end
