//
//  RUNChildViewController.h
//  RunApp
//
//  Created by Tangtang on 2016/11/15.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RUNChartLine = 0,
    RUNChartBar
} RUNChartType;

@interface RUNChildViewController : UIViewController

@property (nonatomic, copy)     NSString        *averValue;
@property (nonatomic, copy)     NSString        *totalValue;
@property (nonatomic, copy)     NSString        *unitStr;
@property (nonatomic, assign)   RUNChartType    chartType;

@end
