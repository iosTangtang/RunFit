//
//  RUNUserModel.m
//  RunApp
//
//  Created by Tangtang on 2016/11/15.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNUserModel.h"

@implementation RUNUserModel

- (void)loadData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.name = [defaults objectForKey:@"userName"];
    self.sex = [defaults objectForKey:@"userSex"];
    self.weight = [defaults objectForKey:@"userWeight"];
    self.height = [defaults objectForKey:@"userHeight"];
    self.tag = [defaults objectForKey:@"userTag"];
}

- (void)saveData:(RUNUserBlock)handle {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.name forKey:@"userName"];
    [defaults setObject:self.sex forKey:@"userSex"];
    [defaults setObject:self.weight forKey:@"userWeight"];
    [defaults setObject:self.height forKey:@"userHeight"];
    [defaults setObject:self.tag forKey:@"userTag"];
    [defaults synchronize];
    handle();
}

- (NSString *)name {
    if (!_name) {
        _name = @"未命名";
    }
    return _name;
}

- (NSString *)sex {
    if (!_sex) {
        _sex = @"男";
    }
    return _sex;
}

- (NSString *)weight {
    if (!_weight) {
        _weight = @"25.0kg";
    }
    return _weight;
}

- (NSString *)height {
    if (!_height) {
        _height = @"50cm";
    }
    return _height;
}

- (NSString *)tag {
    if (!_tag) {
        _tag = @"10000";
    }
    return _tag;
}

@end
