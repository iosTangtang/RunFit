//
//  RUNDataBase.m
//  RunApp
//
//  Created by Tangtang on 2016/12/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNDataBase.h"

@interface RUNDataBase ()

@property (nonatomic, strong) CMPedometer   *pedometer;
@property (nonatomic, strong) RUNUserModel  *userModel;
@property (nonatomic, strong) FMDatabase    *dataBase;

@end

@implementation RUNDataBase

- (instancetype)init {
    self = [super init];
    if (self) {
        [self p_dataBaseInit];
    }
    return self;
}

#pragma mark - Update
- (void)updateDataBaseWithHandle:(RUNDataBaseHandle)handle {
    [self p_launchDataBaseWithHandle:handle];
}

- (void)p_launchDataBaseWithHandle:(RUNDataBaseHandle)handle {
    NSDate *oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldDate"];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSInteger hour = [currentDate timeIntervalSinceDate:[dateFormatter dateFromString:[dateFormatter stringFromDate:currentDate]]];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH";
    currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:currentDate]];
    NSInteger timeDate = [currentDate timeIntervalSinceDate:oldDate];
    NSInteger count = timeDate / 3600;
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"LAUNCH_FIRST"];
    
    if (!isFirst) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LAUNCH_FIRST"];
        count = 7 * 24 + (hour / 3600);
    }
    
    if (count > 1) {
        if (count > (7 * 24) && isFirst) {
            count = 7 * 24;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self p_updateDataWithCount:count handle:handle];
        });
    } else {
        if (handle) {
            handle(NO, count);
        }
    }
}

- (void)p_updateDataWithCount:(NSInteger)count handle:(RUNDataBaseHandle)handle{
    __block NSInteger number = 0;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH";
    currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:currentDate]];
    
    for (int index = 0; index < count; index++) {
        NSDate *fromDate = [currentDate dateByAddingTimeInterval:-3600];
        [self.pedometer queryPedometerDataFromDate:fromDate toDate:currentDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            number++;
            if ([pedometerData.numberOfSteps doubleValue] > 0) {
                double step = [pedometerData.numberOfSteps doubleValue];
                double distance = [pedometerData.distance doubleValue];
                double floor = [pedometerData.floorsAscended doubleValue] + [pedometerData.floorsDescended doubleValue];
                double energy = [self.userModel.weight doubleValue] * ([pedometerData.distance doubleValue] / 1000) * 1.036;
                double duration = [pedometerData.averageActivePace doubleValue] / 60 * [pedometerData.distance doubleValue];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *timeDate = [dateFormatter stringFromDate:fromDate];
                NSString *insertSQL = [NSString stringWithFormat:@"insert into user_data(timeDate, step, energy, duration, distance, floor) values ('%@', %f, %f, %f, %f, %f)", timeDate, step, energy, duration, distance, floor];
                if (![self.dataBase executeUpdate:insertSQL]) {
                    NSLog(@"insert Error");
                }
                if(number == count) {
                    if (handle != nil) {
                        handle(YES, count);
                    }
                }
            }
            
        }];
        currentDate = [currentDate dateByAddingTimeInterval:-3600];
    }
}

#pragma mark - Query
- (NSMutableArray *)queryWithDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSMutableArray *datas = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *fromStr = [dateFormatter stringFromDate:fromDate];
    NSString *selectSQL = [NSString stringWithFormat:@"select timeDate, step, energy, duration, distance, floor from user_data where timeDate like '%%%@%%'", fromStr];
    FMResultSet *resultSet = [self.dataBase executeQuery:selectSQL];
    while ([resultSet next]) {
        NSString *result = [NSString stringWithFormat:@"%@$%f$%f$%f$%f$%f", [resultSet stringForColumn:@"timeDate"],
                                                                            [resultSet doubleForColumn:@"step"],
                                                                            [resultSet doubleForColumn:@"energy"],
                                                                            [resultSet doubleForColumn:@"duration"],
                                                                            [resultSet doubleForColumn:@"distance"],
                                                                            [resultSet doubleForColumn:@"floor"]];
        [datas addObject:result];
    }
    return datas;
}

#pragma mark - Data Base Init
- (void)p_dataBaseInit {
    //获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //设置数据库路径
    NSString *filePath = [path stringByAppendingPathComponent:@"RunFit.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:filePath];
    if (![dataBase open]) {
        NSLog(@"Open DataBase Error");
        return ;
    }
    if (!result) {
        NSString *createSql = [NSString stringWithFormat:@"create table if not exists user_data (id integer primary key,timeDate text UNIQUE,step double default 0,energy double default 0, duration double default 0,distance double default 0,floor double default 0,weight double default 0)"];
        if (![dataBase executeUpdate:createSql]) {
            NSLog(@"Create Table User_Data Error");
            return ;
        }
        
        NSString *createSql2 = [NSString stringWithFormat:@"create table if not exists user_history (id integer primary key,type text,timeDate text,value double default 0,duration double default 0,kcal double default 0,speed double default 0,step double default 0,points blob)"];
        if (![dataBase executeUpdate:createSql2]) {
            NSLog(@"Create Table User_History Error");
            return ;
        }
    }
    self.dataBase = dataBase;
}

#pragma mark - Lazy Load
- (CMPedometer *)pedometer {
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc] init];
    }
    return _pedometer;
}

- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}

@end
