//
//  RUNHealthDataManager.h
//  RunApp
//
//  Created by Tangtang on 2016/12/2.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RUNAuthorizationResult)(BOOL isSuccess);
typedef void(^RUNDataBlock)(NSArray *datas);

typedef enum : NSUInteger {
    RUNDateDayType = 0,
    RUNDateWeekType,
    RUNDateMonthType,
    RUNDateYearType,
    RUNDateNoneType
} RUNDateType;

typedef enum : NSUInteger {
    RUNStepType = 0,
    RUNDistanceType,
    RUNClimbedType,
    RUNWeightType,
    RUNEnergyType
} RUNMotionType;

@interface RUNHealthDataManager : NSObject

- (void)getAuthorizationWithHandle:(RUNAuthorizationResult)handle;

- (void)getHealthCountFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate type:(RUNDateType)type
                    motionType:(RUNMotionType)motionType resultHandle:(RUNDataBlock)handle;

- (void)getHealthWeightCountFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate type:(RUNDateType)type resultHandle:(RUNDataBlock)handle;

@end
