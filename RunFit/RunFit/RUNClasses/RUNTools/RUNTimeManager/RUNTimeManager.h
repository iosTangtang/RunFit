//
//  RUNTimeManager.h
//  RunApp
//
//  Created by Tangtang on 2016/11/22.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUNTimeManager : NSObject

- (NSString *)run_getCurrentDate;
- (NSString *)run_getCurrentTime;
- (NSString *)run_getCurrentDateWithFormatter:(NSString *)formatter;
- (NSString *)run_getDate:(NSDate *)date withFormatter:(NSString *)formatter;

- (NSDate *)run_getDateFromString:(NSString *)dateStr;
- (NSDate *)run_getDateFromString:(NSString *)dateStr withFormatter:(NSString *)formatter;

@end
