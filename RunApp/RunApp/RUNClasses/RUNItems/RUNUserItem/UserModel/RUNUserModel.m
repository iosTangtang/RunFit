//
//  RUNUserModel.m
//  RunApp
//
//  Created by Tangtang on 2016/11/15.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNUserModel.h"

@interface RUNUserModel ()

@property (nonatomic, strong) NSUserDefaults   *defaults;

@end

@implementation RUNUserModel

- (void)loadData {
    self.isLogin = [self.defaults objectForKey:@"isLogin"];
    self.name = [self.defaults objectForKey:@"userName"];
    self.sex = [self.defaults objectForKey:@"userSex"];
    self.weight = [self.defaults objectForKey:@"userWeight"];
    self.height = [self.defaults objectForKey:@"userHeight"];
    self.tag = [self.defaults objectForKey:@"userTag"];
}

- (void)saveData {
    [self.defaults setObject:self.name forKey:@"userName"];
    [self.defaults setObject:self.sex forKey:@"userSex"];
    [self.defaults setObject:self.weight forKey:@"userWeight"];
    [self.defaults setObject:self.height forKey:@"userHeight"];
    [self.defaults setObject:self.tag forKey:@"userTag"];
    [self.defaults synchronize];
}

- (void)saveLoginStatus {
    [self.defaults setObject:self.isLogin forKey:@"isLogin"];
    [self.defaults synchronize];
}

- (NSUserDefaults *)defaults {
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
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

- (NSString *)isLogin {
    if (!_isLogin) {
        _isLogin = @"NO";
    }
    return _isLogin;
}

@end
