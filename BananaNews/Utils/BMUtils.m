//
//  BMUtils.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-2.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMUtils.h"

#import <MMProgressHUD.h>

@implementation BMUtils

#pragma mark - Application's directory

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSDate *)dateFromString:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateStr = [[[str stringByReplacingOccurrencesOfString:@"T" withString:@" "] componentsSeparatedByString:@"+"] objectAtIndex:0];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:dateStr];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringIntervalFromNow:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:date
                                                  toDate:[NSDate date] options:0];
    if ([components year] > 0) {
        return [BMUtils stringFromDate:date];
    }
    else if ([components month] > 0) {
        return [NSString stringWithFormat:@"%u个月前", [components month]];
    }
    else if ([components day] > 0) {
        return [NSString stringWithFormat:@"%u天前", [components day]];
    }
    else if ([components hour] > 0) {
        return [NSString stringWithFormat:@"%u小时前", [components hour]];
    }
    else if ([components minute] > 0) {
        return [NSString stringWithFormat:@"%u分钟前", [components minute]];
    }
    return @"现在";
}

+ (void)showToast:(NSString *)toast
{
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [MMProgressHUD dismissWithSuccess:toast title:nil afterDelay:2];
}

+ (void)showErrorToast:(NSString *)toast
{
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [MMProgressHUD dismissWithError:toast afterDelay:2];
}

@end
