//
//  BMUtils.m
//  BananaNews
//
//  Created by 龚 涛 on 14-1-2.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMUtils.h"

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
    NSDate *date=[formatter dateFromString:dateStr];
    return date;
}

@end
