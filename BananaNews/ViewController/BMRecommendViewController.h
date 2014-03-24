//
//  BMRecommendViewController.h
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMOperateSubView.h"

#import "BMCommonScrollorView.h"

@interface BMRecommendViewController : UIViewController <BMOperateSubViewDelegate, UMSocialUIDelegate>

@property (nonatomic,strong) BMOperateSubView *operateSubview;

@end
