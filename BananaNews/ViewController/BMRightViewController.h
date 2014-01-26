//
//  BMRightViewController.h
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMSNSLoginView.h"

@interface BMRightViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *loginType;

- (void)loginButtonPressed:(id)sender;

@end
