//
//  UITextField+Check.m
//  RunApp
//
//  Created by Tangtang on 2016/12/12.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "UITextField+Check.h"

@implementation UITextField (Check)

- (BOOL)valiMobile {
    NSString *mobile = self.text;
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        return NO;
    }
    // 移动
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    // 联通
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    // 电信
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }
    
    return NO;
}

- (BOOL)valiSMSCode {
    NSString *CODE_NUM = @"[0-9]{6}";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CODE_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:self.text];
    
    return isMatch1;
}

- (BOOL)valiPassword {
    NSString *SPACE_NUM = @"[\\s]";
    NSString *PASS_NUM = @".{6,16}";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", SPACE_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:self.text];
    
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASS_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:self.text];
    
    return !isMatch1 && isMatch2;
}

@end
