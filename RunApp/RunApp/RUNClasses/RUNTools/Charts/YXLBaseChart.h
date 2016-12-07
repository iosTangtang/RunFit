//
//  YXLBaseChart.h
//  Charts
//
//  Created by Tangtang on 2016/10/30.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YXLUnitDay,
    YXLUnitWeak,
    YXLUnitMonth,
    YXLUnitYear
} YXLChartUnit;

static CGFloat const confineX = 40;
static CGFloat const confineY = 20;
static int const standardData = 5000;
static int const dayStandardData = 500;
static CGFloat const pointRaduis = 7;

@interface YXLBaseChart : UIView

@property (nonatomic, strong)   UIColor                 *lineColor;                         // 线条颜色
@property (nonatomic, strong)   UIColor                 *dashLineColor;                     // 虚线颜色
@property (nonatomic, assign)   CGFloat                 lineWidth;                          // 线条宽度
@property (nonatomic, strong)   UIFont                  *labelFont;                         // label字体
@property (nonatomic, strong)   UIColor                 *labelColor;                        // label字体颜色
@property (nonatomic, strong)   UIFont                  *valueLabelFont;                    // 展示数据的label字体
@property (nonatomic, strong)   UIColor                 *valueLabelColor;                   // 展示数据的label字体颜色
@property (nonatomic, assign)   BOOL                    hasDashLine;                        // 是否开启坐标虚线
@property (nonatomic, assign)   BOOL                    hasAnimation;                       // 是否开启动画
@property (nonatomic, assign)   CGFloat                 animationDuration;                  // 动画时间
@property (nonatomic, assign)   BOOL                    hasShowValue;                       // 开启数据提示
@property (nonatomic, assign)   BOOL                    showAllDashLine;                    // 是否使用所有的虚线
@property (nonatomic, assign)   YXLChartUnit            unit;                               // 数据展示时的单位
@property (nonatomic, assign)   NSUInteger              heightXCount;                       // X坐标实际数据个数
@property (nonatomic, copy)     NSArray <NSString *>    *dataArray;                         // 需要制作成图表的数据
@property (nonatomic, copy)     NSArray <NSString *>    *dataXArray;                         // 需要制作成图表的数据
@property (nonatomic, copy)     NSArray <NSString *>    *heightXDatas;                      // X坐标数据
@property (nonatomic, copy)     NSArray <UIColor *>     *backgroundColors;                  // 图标背景渐变颜色组
@property (nonatomic, copy)     NSArray <UIColor *>     *panCakeColors;                     // 饼图中的颜色组

- (void)drawChart;

@end
