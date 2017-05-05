//
//  RUNCloudDataBase.m
//  RunFit
//
//  Created by Tangtang on 2017/5/1.
//  Copyright © 2017年 Tangtang. All rights reserved.
//

#import "RUNCloudDataBase.h"
#import "RUNDataBase.h"
#import "SVProgressHUD.h"
#import "RUNTimeManager.h"
#import <BmobSDK/BmobSDK.h>

const NSInteger kMax = 65535;

@interface RUNCloudDataBase ()

@property (nonatomic, copy)     NSArray             *dataArray;
@property (nonatomic, copy)     NSArray             *historyArray;

@end

@implementation RUNCloudDataBase

- (void)updateToCloudWithBlock:(RunCloudBlock)block {
    [SVProgressHUD showWithStatus:@"数据同步中..."];
    NSString *phoneNumber = [[BmobUser currentUser] objectForKey:@"mobilePhoneNumber"];
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"mobilePhoneNumber" equalTo:phoneNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error || array.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"同步失败，请检查网络设置。"];
        } else {
            BmobUser *user = [array firstObject];
            RUNTimeManager *timeManager = [[RUNTimeManager alloc] init];
            NSDate *date = [timeManager run_getDateFromString:[user objectForKey:@"last_update"] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *historyDate = [timeManager run_getDateFromString:[user objectForKey:@"last_history"] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval interval = 1;
            NSDate *updateDate = [date initWithTimeInterval:interval sinceDate:date];
            NSDate *updateHistoryDate = [historyDate initWithTimeInterval:interval sinceDate:historyDate];
            
            RUNDataBase *dataBase = [[RUNDataBase alloc] init];
            self.dataArray = [dataBase queryWithDataFromDate:updateDate toDate:currentDate];
            self.historyArray = [dataBase queryWithHistoryFromDate:updateHistoryDate toDate:currentDate];

            [self p_betchWithData:self.dataArray withBlock:block];
        }
    }];
}

- (void)p_betchWithData:(NSArray *)data withBlock:(RunCloudBlock)block {
    if (data.count == 0) {
        [self p_updateHistoryWithDate:nil block:block];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int index = 0;
        for (; index < data.count; index++) {
            NSString *str = data[index];
            NSArray *array = [str componentsSeparatedByString:@"$"];
            NSDictionary *dic = @{@"timeDate" : array[0],
                                  @"step" : array[1],
                                  @"energy" : array[2],
                                  @"duration" : array[3],
                                  @"distance" : array[4],
                                  @"floor" : array[5],
                                  @"phoneNumber" : [[BmobUser currentUser] objectForKey:@"mobilePhoneNumber"]};
            BmobObject *obj = [BmobObject objectWithClassName:@"UserData"];
            [obj saveAllWithDictionary:dic];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    if (index == data.count - 1) {
                        NSString *temp = [data firstObject];
                        NSArray *tempArray = [temp componentsSeparatedByString:@"$"];
                        if (self.historyArray.count == 0) {
                            BmobUser *user = [BmobUser currentUser];
                            [user setObject:tempArray[0] forKey:@"last_update"];
                            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        block(isSuccessful, 0, error);
                                    });
                                } else {
                                    NSLog(@"----error %@", error);
                                }
                            }];
                        } else {
                            [self p_updateHistoryWithDate:tempArray[0] block:block];
                        }
                        
                    }
                } else if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"------%@", error);
                        block(isSuccessful, 0, error);
                    });
                }
            }];
            [NSThread sleepForTimeInterval:0.2];
        }
    });
}

- (void)p_updateHistoryWithDate:(NSString *)date block:(RunCloudBlock)block {
    if (self.historyArray.count == 0) {
        block(YES, 1, nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int index = 0;
        for (; index < self.historyArray.count; index++) {
            NSDictionary *dic = self.historyArray[index];
            NSDictionary *dict = @{@"value" : [NSString stringWithFormat:@"%@", dic[@"value"]],
                                  @"type" : dic[@"type"],
                                  @"timeDate" : dic[@"date"],
                                  @"duration" : dic[@"duration"],
                                  @"kcal" : [NSString stringWithFormat:@"%@", dic[@"kcal"]],
                                  @"speed" : [NSString stringWithFormat:@"%@", dic[@"speed"]],
                                  @"step" : [NSString stringWithFormat:@"%@", dic[@"step"]],
                                  @"points" : dic[@"points"],
                                  @"phoneNumber" : [[BmobUser currentUser] objectForKey:@"mobilePhoneNumber"]};
            BmobObject *obj = [BmobObject objectWithClassName:@"History"];
            [obj saveAllWithDictionary:dict];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    if (index == self.historyArray.count - 1) {
                        NSDictionary *tempDic = [self.historyArray firstObject];
                        BmobUser *user = [BmobUser currentUser];
                        if (date != nil) {
                            [user setObject:date forKey:@"last_update"];
                        }
                        [user setObject:tempDic[@"date"] forKey:@"last_history"];
                        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    block(isSuccessful, 0, error);
                                });
                            }
                        }];
                    }
                } else if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"%@", error);
                        block(isSuccessful, 0, error);
                    });
                }
            }];
            [NSThread sleepForTimeInterval:0.2];
        }
    });
}


- (void)downToLocateWithBlock:(RunCloudBlock)block {
    [SVProgressHUD showWithStatus:@"正在同步数据到本地..."];
    
    NSString *phoneNumber = [[BmobUser currentUser] objectForKey:@"mobilePhoneNumber"];
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"mobilePhoneNumber" equalTo:phoneNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error || array.count == 0) {
            NSLog(@"---1 %s %@", __FUNCTION__, error);
            block(NO, 0, error);
        } else {
            BmobUser *user = [array firstObject];
            BmobQuery *bQuery = [BmobQuery queryWithClassName:@"UserData"];
            bQuery.limit = 1000;
            [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (error) {
                    NSLog(@"---2 %s %@", __FUNCTION__, error);
                    block(NO, 0, error);
                } else {
                    self.dataArray = [NSArray arrayWithArray:array];
                    BmobQuery *query = [BmobQuery queryWithClassName:@"History"];
                    query.limit = 1000;
                    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if (error) {
                            NSLog(@"---3 %s %@", __FUNCTION__, error);
                            block(NO, 0, error);
                        } else {
                            self.historyArray = [NSArray arrayWithArray:array];
                            [self p_updateSQLDataWithUser:user block:block];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)p_updateSQLDataWithUser:(BmobUser *)user block:(RunCloudBlock)block {
    
    RUNTimeManager *timeManager = [[RUNTimeManager alloc] init];
    NSDate *date = [timeManager run_getDateFromString:[user objectForKey:@"last_update"] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *historyDate = [timeManager run_getDateFromString:[user objectForKey:@"last_history"] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    
    RUNDataBase *dataBase = [[RUNDataBase alloc] init];
    NSArray *dataArray = [dataBase queryWithDataFromDate:nil toDate:date];
    NSArray *historyArray = [dataBase queryWithHistoryFromDate:nil toDate:historyDate];
    
    for (int index = 0; index < historyArray.count; index++) {
        NSDictionary *dic = historyArray[index];
        NSString *idStr = dic[@"id"];
        [dataBase deleteFromHistoryWithId:[idStr integerValue]];
    }
    
    for (int index = 0; index < dataArray.count; index++) {
        NSString *str = dataArray[index];
        NSArray *array = [str componentsSeparatedByString:@"$"];
        [dataBase deleteFromDataWithTimeDate:array[0]];
    }
    
    for (BmobObject *obj in self.historyArray) {
        NSDictionary *dic = @{@"type" : [obj objectForKey:@"type"],
                              @"date" : [obj objectForKey:@"timeDate"],
                              @"value" : [obj objectForKey:@"value"],
                              @"duration" : [obj objectForKey:@"duration"],
                              @"kcal" : [obj objectForKey:@"kcal"],
                              @"speed" : [obj objectForKey:@"speed"],
                              @"step" : [obj objectForKey:@"step"],
                              @"points" : [obj objectForKey:@"points"]};
        [dataBase insertDataToHistoryWithData:dic handle:^(BOOL isSuccess) {
            if (!isSuccess) {
                NSLog(@"--- %s insert error", __FUNCTION__);
            }
        }];
    }
    
    for (BmobObject *obj in self.dataArray) {
        NSDictionary *dic = @{@"timeDate" : [obj objectForKey:@"timeDate"],
                              @"step" : [obj objectForKey:@"step"],
                              @"duration" : [obj objectForKey:@"duration"],
                              @"energy" : [obj objectForKey:@"energy"],
                              @"distance" : [obj objectForKey:@"distance"],
                              @"floor" : [obj objectForKey:@"floor"]};
        [dataBase insertDataToUserDataWithData:dic handle:^(BOOL isSuccess) {
            if (!isSuccess) {
                NSLog(@"---- %s insert error", __FUNCTION__);
            }
        }];
    }
    
    block(YES, 0, nil);
    
}

@end
