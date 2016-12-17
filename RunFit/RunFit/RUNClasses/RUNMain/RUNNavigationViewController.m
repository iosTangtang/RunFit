//
//  RUNNavigationViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/6.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNNavigationViewController.h"

@interface RUNNavigationViewController ()

@end

@implementation RUNNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //关闭高斯模糊
    [UINavigationBar appearance].translucent = NO;
    //去除导航栏上返回按钮的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1]];
    
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1],
                          NSFontAttributeName:[UIFont systemFontOfSize:17.f]};
    [[UINavigationBar appearance] setTitleTextAttributes:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
