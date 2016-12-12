//
//  RUNHistoryModel.m
//  RunApp
//
//  Created by Tangtang on 2016/12/11.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNHistoryModel.h"
#import "NSString+Hash.h"
#import "RUNTimeManager.h"

@implementation RUNHistoryModel

- (void)saveDataWithHandle:(RUNHistoryData)handle {
    NSString *filePath = [self p_getFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExit = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if (!(isDir && isDirExit)) {
        BOOL isSucceed = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isSucceed) {
            NSLog(@"Create Directory Error");
            if (handle != nil) {
                handle(NO);
            }
            return;
        }
    }
    RUNTimeManager *timeManager = [[RUNTimeManager alloc] init];
    NSString *dateStr = [timeManager run_getCurrentDateWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSString *md5FileName = [dateStr md5String];
    NSString *plistFilePath = [NSString stringWithFormat:@"%@/%@.plist", filePath, md5FileName];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self p_modelToDic]];
    BOOL success = [dic writeToFile:plistFilePath atomically:YES];
    if (handle != nil) {
        handle(success);
    }
}

- (void)loadDataWithFilePath:(NSString *)filePath {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [self p_dicToModel:dic];
}

- (NSString *)p_getFilePath {
    NSArray *cachePathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = cachePathArray[0];
    return [cachePath stringByAppendingPathComponent:@"RunFit"];
}

- (NSDictionary *)p_modelToDic {
    return @{@"type" : _type,
             @"date" : _date,
             @"value" : _value,
             @"duration" : _duration,
             @"kcal" : _kcal,
             @"speed" : _speed,
             @"step" : _step,
             @"points" : _points};
}

- (void)p_dicToModel:(NSDictionary *)dic {
    self.type = dic[@"type"];
    self.date = dic[@"date"];
    self.value = dic[@"value"];
    self.duration = dic[@"duration"];
    self.kcal = dic[@"kcal"];
    self.speed = dic[@"speed"];
    self.step = dic[@"step"];
    self.points = dic[@"points"];
}

@end
