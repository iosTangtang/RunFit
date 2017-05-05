//
//  RUNUserModel.h
//  RunApp
//
//  Created by Tangtang on 2016/11/15.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUNUserModel : NSObject

@property (nonatomic, copy)     NSString    *name;
@property (nonatomic, copy)     NSString    *sex;
@property (nonatomic, copy)     NSString    *weight;
@property (nonatomic, copy)     NSString    *height;
@property (nonatomic, copy)     NSString    *tag;
@property (nonatomic, copy)     NSString    *isLogin;

- (void)loadData;
- (void)saveData;
- (void)saveLoginStatus;

@end
