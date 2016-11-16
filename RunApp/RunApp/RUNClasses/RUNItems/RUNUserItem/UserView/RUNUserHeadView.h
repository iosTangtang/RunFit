//
//  RUNUserHeadView.h
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUNUserHeadView : UIView

- (void)setUserName:(NSString *)name;                                       // 设置用户名
- (void)setUserImage:(UIImage *)image;                                      // 设置用户头像
- (void)setUserHeight:(CGFloat)height;                                    // 设置用户身高
- (void)setUserWeight:(CGFloat)weight;                                    // 设置用户体重
- (void)setUserBMI:(CGFloat)bmi;                                            // 设置用户BMI值
- (void)setUserTarget:(NSInteger)target;                                    // 设置用户目标

@end
