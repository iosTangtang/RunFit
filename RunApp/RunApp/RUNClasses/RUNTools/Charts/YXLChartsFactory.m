//
//  YXLChartsFactory.m
//  Charts
//
//  Created by Tangtang on 2016/10/30.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "YXLChartsFactory.h"
#import "YXLLineChart.h"
#import "YXLColumChart.h"

@implementation YXLChartsFactory

+ (YXLBaseChart *)chartsFactory:(YXLChartType)chartType {
    YXLBaseChart *base = nil;
    switch (chartType) {
        case YXLChartLine:
            base = [[YXLLineChart alloc] initWithFrame:CGRectZero];
            break;
        case YXLChartColumnar:
            base = [[YXLColumChart alloc] initWithFrame:CGRectZero];
            break;
        case YXLChartPanCake:
            break;
            
        default:
            base = [[YXLLineChart alloc] initWithFrame:CGRectZero];
            break;
    }
    
    base.lineColor = [UIColor whiteColor];
    base.lineWidth = 2.f;
    base.hasAnimation = YES;
    base.dashLineColor = [UIColor colorWithRed:255 / 255.0 green:227 / 255.0 blue:123 / 255.0 alpha:0.8];
    base.valueLabelFont = [UIFont systemFontOfSize:14.f];
    base.valueLabelColor = [UIColor grayColor];
    base.animationDuration = 0.5f;
    base.labelFont = [UIFont systemFontOfSize:10.f];
    base.labelColor = [UIColor colorWithRed:202 / 255.0 green:202 / 255.0 blue:202 / 255.0 alpha:1];
    base.hasDashLine = YES;
    base.hasShowValue = NO;
    base.showAllDashLine = YES;
    base.backgroundColors = @[(__bridge id)[UIColor colorWithRed:253 / 255.0 green:164 / 255.0 blue:8 / 255.0 alpha:1.0].CGColor,
                              (__bridge id)[UIColor colorWithRed:251 / 255.0 green:37 / 255.0 blue:45 / 255.0 alpha:1.0].CGColor];
    
    return base;
}

@end
