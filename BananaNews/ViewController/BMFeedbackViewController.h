//
//  FeedbackViewController.h
//  JikeNews
//
//  Created by changda on 12-12-9.
//  Copyright (c) 2012年 Jike. All rights reserved.
//

#import "BMBaseSubViewController.h"

#import <UMFeedback.h>

@interface BMFeedbackViewController : BMBaseSubViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UMFeedbackDataDelegate>
{
    UMFeedback *feedbackClient;
    UIView *_feedbackView;
}

@property (nonatomic, strong) UITextField *mTextField;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIToolbar   *mToolBar;

@property (nonatomic, retain)  NSArray *mFeedbackDatas;

@end
