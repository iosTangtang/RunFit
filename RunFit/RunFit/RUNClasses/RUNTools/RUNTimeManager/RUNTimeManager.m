//
//  RUNTimeManager.m
//  RunApp
//
//  Created by Tangtang on 2016/11/22.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNTimeManager.h"

@implementation RUNTimeManager

#pragma mark - Date To String
- (NSString *)run_getCurrentDate {
    return [self run_getCurrentDateWithFormatter:@"yyyy年MM月dd日"];
}

- (NSString *)run_getCurrentTime {
    return [self run_getCurrentDateWithFormatter:@"HH:mm:ss"];
}

- (NSString *)run_getCurrentDateWithFormatter:(NSString *)formatter {
    NSDate *currentDate = [NSDate date];
    return [self run_getDate:currentDate withFormatter:formatter];
}

- (NSString *)run_getDate:(NSDate *)date withFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:date];
}

#pragma mark - String To Date
- (NSDate *)run_getDateFromString:(NSString *)dateStr {
    return [self run_getDateFromString:dateStr withFormatter:@"yyyy年MM月dd日 HH:mm:ss"];
}

- (NSDate *)run_getDateFromString:(NSString *)dateStr withFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString:dateStr];
}

@end
