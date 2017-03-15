//
//  RUNHistoryModel.m
//  RunApp
//
//  Created by Tangtang on 2016/12/11.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNHistoryModel.h"
#import "NSString+Hash.h"
#import "RUNDataBase.h"

@interface RUNHistoryModel ()

@property (nonatomic, strong) RUNDataBase           *dataBase;

@end

@implementation RUNHistoryModel

- (void)saveDataWithHandle:(RUNHistoryData)handle {
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self p_modelToDic]];
    [self.dataBase insertDataToHistoryWithData:dic handle:^(BOOL isSuccess) {
        if (isSuccess) {
            handle(YES);
        } else {
            handle(NO);
        }
    }];
}

- (NSDictionary *)p_modelToDic {
    return @{@"type" : _type,
             @"date" : _date,
             @"value" : @(_value),
             @"duration" : _duration,
             @"kcal" : @(_kcal),
             @"speed" : @(_speed),
             @"step" : @(_step),
             @"points" : _points};
}

- (void)dicToModel:(NSDictionary *)dic {
    self.id = dic[@"id"];
    self.type = dic[@"type"];
    self.date = dic[@"date"];
    self.value = [dic[@"value"] doubleValue];
    self.duration = dic[@"duration"];
    self.kcal = [dic[@"kcal"] doubleValue];
    self.speed = [dic[@"speed"] doubleValue];
    self.step = [dic[@"step"] doubleValue];
    self.points = dic[@"points"];
}

- (RUNDataBase *)dataBase {
    if (!_dataBase) {
        _dataBase = [[RUNDataBase alloc] init];
    }
    return _dataBase;
}

@end
