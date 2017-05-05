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
    
    base.lineColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
    base.lineWidth = 5.f;
    base.hasAnimation = YES;
    base.dashLineColor = [UIColor colorWithRed:230 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:0.6];
    base.valueLabelFont = [UIFont systemFontOfSize:14.f];
    base.valueLabelColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
    base.animationDuration = 1.f;
    base.labelFont = [UIFont systemFontOfSize:10.f];
    base.labelColor = [UIColor colorWithRed:202 / 255.0 green:202 / 255.0 blue:202 / 255.0 alpha:1];
    base.hasDashLine = YES;
    base.hasShowValue = NO;
    base.showAllDashLine = YES;
    base.backgroundColors = @[(__bridge id)[UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor,
                              (__bridge id)[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1].CGColor];
    
    return base;
}

@end
