//
//  BMDetailNewsViewController.h
//  BananaNews
//
//  Created by 龚涛 on 12/31/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMRootViewController.h"

#import "BMSNSLoginView.h"

@interface BMDetailNewsViewController : BMRootViewController <UITextViewDelegate, UMSocialUIDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) News *news;

@end
