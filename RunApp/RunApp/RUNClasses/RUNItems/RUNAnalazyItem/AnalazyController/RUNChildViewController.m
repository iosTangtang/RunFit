//
//  RUNChildViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/15.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNChildViewController.h"
#import "YXLBaseChart.h"
#import "YXLChartsFactory.h"
#import "RUNUserModel.h"
#import "RUNHealthDataManager.h"
#import "RUNAllDataViewController.h"

static CGFloat const animationDuration = 1.f;
static CGFloat const barChartLineWidth = 8.f;
static CGFloat const lineChartLineWidth = 6.f;

typedef void(^RUNAllDataBlock)(NSArray *datas);

@interface RUNChildViewController () {
    CGFloat _lastWeight;
}

@property (nonatomic, strong) UISegmentedControl        *segmented;
@property (nonatomic, strong) RUNHealthDataManager      *healthManager;
@property (nonatomic, strong) YXLBaseChart              *barChart;
@property (nonatomic, strong) UILabel                   *aver;
@property (nonatomic, strong) UILabel                   *total;
@property (nonatomic, strong) NSMutableArray            *dataCache;
@property (nonatomic, strong) NSMutableArray            *dateCache;
@property (nonatomic, strong) NSMutableArray            *dateXCache;
@property (nonatomic, assign) BOOL                      isSuccess;
@property (nonatomic, assign) RUNMotionType             motionType;
@property (nonatomic, strong) RUNUserModel              *userModel;

@end

@implementation RUNChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    [self dateCache];
    [self dateXCache];
    
    [self p_setupSegmented];
    [self p_dataOperationWithIndex:0];
    [self p_setChartView];
    [self p_setAllDataButton];
    [self p_label];
    
    // 请求权限
    __weak typeof(self) weakSelf = self;
    [self.healthManager getAuthorizationWithHandle:^(BOOL isSuccess) {
        weakSelf.isSuccess = isSuccess;
        [weakSelf p_dataOperationWithIndex:0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initalize
- (void)p_setChartView {
    [self.barChart drawChart];
    [self.view addSubview:self.barChart];
    
    [self.barChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(-50);
        make.left.equalTo(self.view.left).offset(25);
        make.right.equalTo(self.view.right).offset(-25);
        make.width.equalTo(ViewWidth - 50);
        make.height.equalTo(ViewHeight / 2);
    }];
}

#pragma mark - Set All Data Button 
- (void)p_setAllDataButton {
    UIButton *allDataButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [allDataButton setTitle:@"显示所有数据" forState:UIControlStateNormal];
    [allDataButton setTitleColor:[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1] forState:UIControlStateNormal];
    allDataButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [allDataButton addTarget:self action:@selector(p_allDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allDataButton];
    
    [allDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.bottom).offset(-10);
        make.height.equalTo(30);
        make.width.equalTo(100);
    }];
}

#pragma mark - Set Label
- (void)p_label {
    UILabel *averLabel = [[UILabel alloc] init];
    averLabel.text = @"平均值:";
    if (self.motionType == RUNWeightType) {
        averLabel.text = @"最新值:";
    }
    averLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
    [self.view addSubview:averLabel];
    [averLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(ViewHeight / 10.0);
        make.left.equalTo(self.view.left).offset(24);
        make.width.equalTo(60);
        make.height.equalTo(20);
    }];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.text = self.unitStr;
    totalLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
    [self.view addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(averLabel.bottom).offset(20);
        make.left.equalTo(self.view.left).offset(24);
        make.width.equalTo(60);
        make.height.equalTo(20);
    }];
    
    [self.aver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(averLabel.right).offset(20);
        make.top.equalTo(averLabel.top);
        make.width.equalTo(ViewWidth / 3 * 2);
        make.height.equalTo(20);
    }];
    
    [self.total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalLabel.right).offset(20);
        make.top.equalTo(totalLabel.top);
        make.width.equalTo(ViewWidth / 3 * 2);
        make.height.equalTo(20);
    }];
    
}

#pragma mark - Set segmented
- (void)p_setupSegmented {
    NSArray *segArray = @[@"日", @"周", @"月", @"年"];
    self.segmented = [[UISegmentedControl alloc] initWithItems:segArray];
    self.segmented.selectedSegmentIndex = 0;
    self.segmented.tintColor = [UIColor colorWithRed:69 / 255.0 green:202 / 255.0 blue:240 / 255.0 alpha:1];
    [self.segmented addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmented];
    
    [self.segmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(3);
        make.height.equalTo(29);
    }];

}

#pragma mark - 切换视图方法
- (void)changeView:(UISegmentedControl *)segment {
    int index = 0;
    switch (segment.selectedSegmentIndex) {
        case 0:
            self.barChart.unit = YXLUnitDay;
            self.barChart.heightXDatas = self.dateXCache[0];
            self.barChart.dataXArray = self.dateCache[0];
            self.barChart.dataArray = [self.dataCache objectAtIndex:0];
            index = 0;
            break;
        case 1:
            self.barChart.unit = YXLUnitWeak;
            self.barChart.heightXDatas = self.dateXCache[1];
            self.barChart.dataXArray = self.dateCache[1];
            self.barChart.dataArray = [self.dataCache objectAtIndex:1];
            index = 1;
            break;
        case 2:
            self.barChart.unit = YXLUnitMonth;
            self.barChart.heightXDatas = self.dateXCache[2];
            self.barChart.dataXArray = self.dateCache[2];
            self.barChart.dataArray = [self.dataCache objectAtIndex:2];
            index = 2;
            break;
        case 3:
            self.barChart.unit = YXLUnitYear;
            self.barChart.heightXDatas = self.dateXCache[3];
            self.barChart.dataXArray = self.dateCache[3];
            self.barChart.dataArray = [self.dataCache objectAtIndex:3];
            index = 3;
            break;
            
        default:
            break;
    }
    
    if ([self.barChart.dataArray isEqualToArray:@[@"0"]]) {
        [self p_dataOperationWithIndex:index];
    } else {
        [self.barChart removeFromSuperview];
        NSArray *array = [self p_getAverAndTotalWithArray:self.barChart.dataArray];
        self.aver.text = [NSString stringWithFormat:@"%.0f %@", [array[1] doubleValue], self.unit];
        self.total.text = [NSString stringWithFormat:@"%.0f %@", [array[0] doubleValue], self.unit];
        if (self.motionType == RUNDistanceType || self.motionType == RUNEnergyType) {
            self.aver.text = [NSString stringWithFormat:@"%.1f %@", [array[1] doubleValue] / 1000, self.unit];
            self.total.text = [NSString stringWithFormat:@"%.1f %@", [array[0] doubleValue] / 1000, self.unit];
        } else if (self.motionType == RUNWeightType) {
            self.aver.text = [NSString stringWithFormat:@"%.1f %@", _lastWeight, self.unit];
            self.total.text = [NSString stringWithFormat:@"%.1f", _lastWeight / pow([self.userModel.height doubleValue] / 100, 2)];
            if (index == 0) {
                self.aver.text = [NSString stringWithFormat:@"0.0 %@", self.unit];
                self.total.text = @"0.0";
            }
        }
        [self p_setChartView];
    }
}

#pragma mark - All Data Button Action
- (void)p_allDataButtonAction:(UIButton *)button {
    [self p_getAllDataWithMotionType:self.motionType handle:^(NSArray *datas) {
        dispatch_async(dispatch_get_main_queue(), ^{
            RUNAllDataViewController *allDataVC = [[RUNAllDataViewController alloc] init];
            allDataVC.title = self.title;
            allDataVC.unit = self.unit;
            allDataVC.dataArray = datas;
            allDataVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:allDataVC animated:YES];
        });
    }];
}

#pragma mark - Get Date
- (NSArray *)p_getDateWithIndex:(NSInteger)index {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components:flags fromDate:nowDate];
    NSInteger hour = dateComponents.hour;
    NSInteger minute = dateComponents.minute;
    NSInteger second = dateComponents.second;
    NSInteger dayTime = 86400 - (hour * 3600 + minute * 60 + second);
    NSDate *nowDay = nil;
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:dayTime];
    
    switch (index) {
        case 0:
            nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400];
            break;
        case 1:
            nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400 * 7];
            break;
        case 2:
            nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400 * 30];
            break;
        case 3:
            nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400 * 30 * 11];
            break;
        default:
            break;
    }
    
    return @[nowDay, nextDay];
}

#pragma mark - Get Aver
- (NSArray *)p_getAverAndTotalWithArray:(NSArray *)array {
    NSInteger sum = 0;
    for (NSString *obj in array) {
        sum += [obj integerValue];
    }
    NSInteger aver = sum / array.count;
    
    return @[@(sum), @(aver)];
}

#pragma mark - Data Operation
- (void)p_dataOperationWithIndex:(NSInteger)index {
    if (!self.isSuccess) {
        return ;
    }
    if ([self.title isEqualToString:@"步数"]) {
        [self p_getMotionDataWithtype:index motionType:self.motionType];
    } else if ([self.title isEqualToString:@"体重"]) {
        [self p_getMotionDataWithtype:index motionType:self.motionType];
    } else if ([self.title isEqualToString:@"公里"]) {
        [self p_getMotionDataWithtype:index motionType:self.motionType];
    }else if ([self.title isEqualToString:@"楼层"]) {
        [self p_getMotionDataWithtype:index motionType:self.motionType];
    } else if ([self.title isEqualToString:@"卡路里"]) {
        [self p_getMotionDataWithtype:index motionType:self.motionType];
    }
    
}

- (void)p_getMotionDataWithtype:(NSInteger)index motionType:(RUNMotionType)motionType {
    NSMutableArray *barData = [NSMutableArray array];
    NSArray *dates = [self p_getDateWithIndex:index];
    NSArray *cacheDate = self.dateCache[index];
    int countX = 0;
    if (index == 0) {
        countX = 24;
    } else if (index == 1) {
        countX = 7;
    } else if (index == 2) {
        countX = 30;
    } else {
        countX = 12;
    }
    [self.healthManager getHealthCountFromDate:dates[0] toDate:dates[1] type:index motionType:motionType resultHandle:^(NSArray *datas) {
        if (dates != nil) {
            int count = 0;
            for (int index = 0; index < countX; index++) {
                if (count >= datas.count) {
                    [barData addObject:@"0"];
                    continue;
                }
                
                NSNumber *value = [datas[count] objectForKey:cacheDate[index]];
                if (value == nil) {
                    [barData addObject:@"0"];
                } else {
                    [barData addObject:[NSString stringWithFormat:@"%@", value]];
                    _lastWeight = [value doubleValue];
                    count++;
                }
            }
        } else {
            [barData addObject:@"0"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.barChart removeFromSuperview];
            NSArray *array = [self p_getAverAndTotalWithArray:barData];
            self.barChart.dataArray = barData;
            self.aver.text = [NSString stringWithFormat:@"%.0f %@", [array[1] doubleValue], self.unit];
            self.total.text = [NSString stringWithFormat:@"%.0f %@", [array[0] doubleValue], self.unit];
            if (motionType == RUNDistanceType || motionType == RUNEnergyType) {
                self.aver.text = [NSString stringWithFormat:@"%.1f %@", [array[1] doubleValue] / 1000, self.unit];
                self.total.text = [NSString stringWithFormat:@"%.1f %@", [array[0] doubleValue] / 1000, self.unit];
            } else if (motionType == RUNWeightType) {
                self.aver.text = [NSString stringWithFormat:@"%.1f %@", _lastWeight, self.unit];
                self.total.text = [NSString stringWithFormat:@"%.1f", _lastWeight / pow([self.userModel.height doubleValue] / 100, 2)];
            }
            [self.dataCache replaceObjectAtIndex:index withObject:barData];
            [self p_setChartView];
        });
    }];
}

- (void)p_getAllDataWithMotionType:(RUNMotionType)motionType handle:(RUNAllDataBlock)handle  {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components:flags fromDate:nowDate];
    NSInteger hour = dateComponents.hour;
    NSInteger minute = dateComponents.minute;
    NSInteger second = dateComponents.second;
    NSInteger dayTime = 86400 - (hour * 3600 + minute * 60 + second);
    NSDate *nowDay = nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400 * 365 * 3];
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:dayTime];
    
    [self.healthManager getHealthCountFromDate:nowDay toDate:nextDay type:4 motionType:motionType resultHandle:^(NSArray *datas) {
        handle(datas);
    }];
}

- (NSArray *)p_getDateCacheWithIndex:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSArray *dates = [self p_getDateWithIndex:index];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *startDate = dates[0];
    if (index == 0) {
        formatter.dateFormat = @"HH";
        [array addObject:[formatter stringFromDate:startDate]];
        for (int index = 0; index < 23; index++) {
            startDate = [calendar dateByAddingUnit:NSCalendarUnitHour value:1 toDate:startDate options:0];
            [array addObject:[formatter stringFromDate:startDate]];
        }
    } else if (index == 1) {
        formatter.dateFormat = @"dd";
        [array addObject:[formatter stringFromDate:startDate]];
        for (int index = 0; index < 6; index++) {
            startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
            [array addObject:[formatter stringFromDate:startDate]];
        }
    } else if (index == 2) {
        formatter.dateFormat = @"dd";
        [array addObject:[formatter stringFromDate:startDate]];
        for (int index = 0; index < 29; index++) {
            startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
            [array addObject:[formatter stringFromDate:startDate]];
        }
    } else {
        formatter.dateFormat = @"yyyy/MM";
        [array addObject:[formatter stringFromDate:startDate]];
        for (int index = 0; index < 11; index++) {
            startDate = [calendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:startDate options:0];
            [array addObject:[formatter stringFromDate:startDate]];
        }
    }
    return array;
}

- (NSArray *)p_getDateXCacheWithIndex:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *dates = [self p_getDateCacheWithIndex:index];
    if (index == 0) {
        array = [NSMutableArray arrayWithArray:@[@"上午", @"中午12时", @"下午"]];
    } else if (index == 1) {
        for (NSString *obj in dates) {
            NSInteger time = [obj integerValue];
            [array addObject:[NSString stringWithFormat:@"%ld日", (long)time]];
        }
    } else if (index == 2) {
        for (int index = 1; index < 6; index++) {
            NSInteger time = [dates[index * 6 - 1] integerValue];
            [array addObject:[NSString stringWithFormat:@"%ld日", (long)time]];
        }
    } else {
        for (int index = 1; index < 5; index++) {
            [array addObject:dates[index * 3 - 1]];
        }
    }
    return array;
}

#pragma mark - Lazy Load
- (UILabel *)aver {
    if (!_aver) {
        _aver = [[UILabel alloc] init];
        _aver.text = [NSString stringWithFormat:@"0 %@", self.unit];
        _aver.textColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
        [self.view addSubview:_aver];
    }
    return _aver;
}

- (UILabel *)total {
    if (!_total) {
        _total = [[UILabel alloc] init];
        _total.text = [NSString stringWithFormat:@"0 %@", self.unit];
        _total.textColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
        [self.view addSubview:_total];
    }
    return _total;
}

- (RUNHealthDataManager *)healthManager {
    if (!_healthManager) {
        _healthManager = [[RUNHealthDataManager alloc] init];
    }
    return _healthManager;
}

- (YXLBaseChart *)barChart {
    if (!_barChart) {
        if (self.chartType == RUNChartBar) {
            _barChart = [YXLChartsFactory chartsFactory:YXLChartColumnar];
            _barChart.lineWidth = barChartLineWidth;
        } else {
            _barChart = [YXLChartsFactory chartsFactory:YXLChartLine];
            _barChart.lineWidth = lineChartLineWidth;
        }
        _barChart.bounds = CGRectMake(0, 0, ViewWidth - 50, ViewHeight / 2);
        _barChart.hasShowValue = YES;
        _barChart.animationDuration = animationDuration;
        _barChart.showAllDashLine = NO;
        _barChart.unit = YXLUnitDay;
        _barChart.dataXArray = self.dateCache[0];
        _barChart.heightXDatas = self.dateXCache[0];
    }
    return _barChart;
}

- (NSMutableArray *)dataCache {
    if (!_dataCache) {
        _dataCache = [NSMutableArray arrayWithArray:@[@[@"0"], @[@"0"], @[@"0"], @[@"0"]]];
    }
    return _dataCache;
}

- (NSMutableArray *)dateCache {
    if (!_dateCache) {
        _dateCache = [NSMutableArray arrayWithArray:@[[self p_getDateCacheWithIndex:0],
                                                      [self p_getDateCacheWithIndex:1],
                                                      [self p_getDateCacheWithIndex:2],
                                                      [self p_getDateCacheWithIndex:3]]];
    }
    return _dateCache;
}

- (NSMutableArray *)dateXCache {
    if (!_dateXCache) {
        _dateXCache = [NSMutableArray arrayWithArray:@[[self p_getDateXCacheWithIndex:0],
                                                      [self p_getDateXCacheWithIndex:1],
                                                      [self p_getDateXCacheWithIndex:2],
                                                      [self p_getDateXCacheWithIndex:3]]];
    }
    return _dateXCache;
}

- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}

- (RUNMotionType)motionType {
    if (!_motionType) {
        if ([self.title isEqualToString:@"步数"]) {
            _motionType = RUNStepType;
        } else if ([self.title isEqualToString:@"体重"]) {
            _motionType = RUNWeightType;
        } else if ([self.title isEqualToString:@"公里"]) {
            _motionType = RUNDistanceType;
        }else if ([self.title isEqualToString:@"楼层"]) {
            _motionType = RUNClimbedType;
        } else if ([self.title isEqualToString:@"卡路里"]) {
            _motionType = RUNEnergyType;
        }
    }
    return _motionType;
}

@end
