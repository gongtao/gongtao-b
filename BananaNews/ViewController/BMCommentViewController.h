//
//  BMCommentViewController.h
//  BananaNews
//
//  Created by 龚涛 on 3/24/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMBaseSubViewController.h"

#import "BMSNSLoginView.h"

#import "BMCommentTableViewController.h"

@protocol BMCommentViewControllerDelegate <NSObject>

- (void)didCancelCommentViewController;

@end

@interface BMCommentViewController : BMBaseSubViewController <UITextFieldDelegate, UIAlertViewDelegate, BMCommentTableViewControllerDelegate>

@property (nonatomic, strong) News *news;

@property (nonatomic, assign) id<BMCommentViewControllerDelegate> delegate;

@end
