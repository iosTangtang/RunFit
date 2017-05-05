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

#pragma mark - Insert
- (void)insertDataBaseWithHandle:(RUNDataBaseHandle)handle {
    [self p_insertDataBaseWithHandle:handle];
}

- (void)p_insertDataBaseWithHandle:(RUNDataBaseHandle)handle {
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

- (void)insertDataToUserDataWithData:(NSDictionary *)data handle:(RUNHistoryHandle)handle {
    [self.dataBase beginTransaction];
    BOOL isRollBack = NO;
    if (![self.dataBase executeUpdate:@"insert into user_data(timeDate, step, energy, duration, distance, floor) values (?, ?, ?, ?, ?, ?)", data[@"timeDate"], data[@"step"], data[@"energy"], data[@"duration"], data[@"distance"], data[@"floor"]])
    {
        isRollBack = YES;
        [self.dataBase rollback];
        handle(NO);
    } else {
        handle(YES);
    }
    [self.dataBase commit];
    
}

- (void)insertDataToHistoryWithData:(NSDictionary *)data handle:(RUNHistoryHandle)handle {
    NSData *pointsDataUrl = [NSKeyedArchiver archivedDataWithRootObject:data[@"points"]];
    [self.dataBase beginTransaction];
    BOOL isRollBack = NO;
    NSString *time = [NSString stringWithFormat:@"%@", data[@"date"]];
    if (![self.dataBase executeUpdate:@"insert into user_history(type, timeDate, value, duration, kcal, speed, step, points) values (?,?,?,?,?,?,?,?)", data[@"type"], time, data[@"value"], data[@"duration"], data[@"kcal"], data[@"speed"], data[@"step"], pointsDataUrl])
    {
        isRollBack = YES;
        [self.dataBase rollback];
        handle(NO);
    } else {
       handle(YES);
    }
    [self.dataBase commit];
    
}

#pragma mark - Query
- (NSMutableArray *)queryWithDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSMutableArray *datas = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *fromStr = [dateFormatter stringFromDate:fromDate];
    if (fromDate == nil) {
        fromStr = @"";
    }
    NSString *toStr = [dateFormatter stringFromDate:toDate];
    NSString *selectSQL = [NSString stringWithFormat:@"select timeDate, step, energy, duration, distance, floor from user_data where timeDate between '%@' and '%@' order by timeDate DESC", fromStr, toStr];
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

- (NSMutableArray *)queryWithHistoryFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSMutableArray *datas = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *fromStr = [dateFormatter stringFromDate:fromDate];
    if (fromDate == nil) {
        fromStr = @"";
    }
    NSString *toStr = [dateFormatter stringFromDate:toDate];
    NSString *selectSQL = [NSString stringWithFormat:@"select id, type, timeDate, value, duration, kcal, speed, step, points from user_history where timeDate between '%@' and '%@' order by timeDate DESC", fromStr, toStr];
    FMResultSet *resultSet = [self.dataBase executeQuery:selectSQL];
    NSArray *points = nil;
    while ([resultSet next]) {
        NSString *weightStr = [resultSet stringForColumn:@"type"];
        if (![weightStr isEqualToString:@"humanWeight"]) {
            points = [NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"points"]];
        }
        if (points == nil) {
            points = [NSArray array];
        }
        NSDictionary *dic = @{@"id" : [resultSet stringForColumn:@"id"],
                              @"type" : weightStr,
                              @"date" : [resultSet stringForColumn:@"timeDate"],
                              @"value" : @([resultSet doubleForColumn:@"value"]),
                              @"duration" : [resultSet stringForColumn:@"duration"],
                              @"kcal" : @([resultSet doubleForColumn:@"kcal"]),
                              @"speed" : @([resultSet doubleForColumn:@"speed"]),
                              @"step" : @([resultSet doubleForColumn:@"step"]),
                              @"points" : points};
        [datas addObject:dic];
    }
    return datas;
}

- (NSMutableArray *)queryDataWithLimitNumber:(NSInteger)number pagesNumber:(NSInteger)pageNumber {
    NSMutableArray *datas = [NSMutableArray array];
    NSString *querySQL = [NSString stringWithFormat:@"select id, type, timeDate, value, duration, kcal, speed, step, points from user_history limit %zd,%zd", number, pageNumber];
    FMResultSet *resultSet = [self.dataBase executeQuery:querySQL];
    NSArray *points = nil;
    while ([resultSet next]) {
        NSString *weightStr = [resultSet stringForColumn:@"type"];
        if (![weightStr isEqualToString:@"humanWeight"]) {
            points = [NSKeyedUnarchiver unarchiveObjectWithData:[resultSet dataForColumn:@"points"]];
        }
        if (points == nil) {
            points = [NSArray array];
        }
        NSDictionary *dic = @{@"id" : [resultSet stringForColumn:@"id"],
                              @"type" : weightStr,
                              @"date" : [resultSet stringForColumn:@"timeDate"],
                              @"value" : @([resultSet doubleForColumn:@"value"]),
                              @"duration" : [resultSet stringForColumn:@"duration"],
                              @"kcal" : @([resultSet doubleForColumn:@"kcal"]),
                              @"speed" : @([resultSet doubleForColumn:@"speed"]),
                              @"step" : @([resultSet doubleForColumn:@"step"]),
                              @"points" : points};
        [datas addObject:dic];
    }
    
    return datas;
}

- (NSMutableArray *)queryWeightDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSMutableArray *datas = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *fromStr = [dateFormatter stringFromDate:fromDate];
    if (fromDate == nil) {
        fromStr = @"";
    }
    NSString *toStr = [dateFormatter stringFromDate:toDate];
    NSString *querySQL = [NSString stringWithFormat:@"select type, timeDate, value from user_history where type = 'humanWeight' and timeDate between '%@' and '%@'", fromStr, toStr];
    FMResultSet *resultSet = [self.dataBase executeQuery:querySQL];
    
    while ([resultSet next]) {
        NSString *result = [NSString stringWithFormat:@"%@$%@$%f", [resultSet stringForColumn:@"timeDate"], [resultSet stringForColumn:@"type"],
                                                                    [resultSet doubleForColumn:@"value"]];
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
        
        NSString *createSql2 = [NSString stringWithFormat:@"create table if not exists user_history (id integer primary key,type text,timeDate text,value double default 0,duration text,kcal double default 0,speed double default 0,step double default 0,points blob)"];
        if (![dataBase executeUpdate:createSql2]) {
            NSLog(@"Create Table User_History Error");
            return ;
        }
    }
    self.dataBase = dataBase;
}

#pragma mark - Delete Data
- (BOOL)deleteFromHistoryWithId:(NSInteger)id {
    NSString *deleteSql = [NSString stringWithFormat:@"delete from user_history where id = %zd", id];
    return [self.dataBase executeUpdate:deleteSql];
}

- (BOOL)deleteFromDataWithTimeDate:(NSString *)timeDate {
    NSString *deleteSql = [NSString stringWithFormat:@"delete from user_data where timeDate = '%@'", timeDate];
    return [self.dataBase executeUpdate:deleteSql];
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
