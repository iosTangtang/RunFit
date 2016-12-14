//
//  RUNDataBase.h
//  RunApp
//
//  Created by Tangtang on 2016/12/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNUserModel.h"
#import "FMDB.h"
#import <CoreMotion/CoreMotion.h>

typedef void(^RUNDataBaseHandle)(BOOL isUpdate, NSInteger count);
typedef void(^RUNResultDataHandle)(NSArray *datas);

@interface RUNDataBase : NSObject

- (void)updateDataBaseWithHandle:(RUNDataBaseHandle)handle;

- (NSMutableArray *)queryWithDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end
