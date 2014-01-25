//
//  BMUtils.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-2.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMUtils : NSObject

+ (NSURL *)applicationDocumentsDirectory;

+ (NSDate *)dateFromString:(NSString *)str;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)stringIntervalFromNow:(NSDate *)date;

+ (void)showToast:(NSString *)toast;

+ (void)showErrorToast:(NSString *)toast;

@end
