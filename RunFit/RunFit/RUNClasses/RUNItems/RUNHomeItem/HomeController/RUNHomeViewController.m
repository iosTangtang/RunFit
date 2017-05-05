//
//  RUNHomeViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/6.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNHomeViewController.h"
#import "RUNCircleView.h"
#import "RUNTextView.h"
#import "YXLChartsFactory.h"
#import "YXLBaseChart.h"
#import "RUNShareViewController.h"
#import "RUNMapViewController.h"
#import "RUNFuncViewController.h"
#import "RUNCalendarViewController.h"
#import "RUNFAQViewController.h"
#import "UIViewController+ScreenShot.h"
#import "RUNWeightViewController.h"
#import "RUNTimeManager.h"
#import "RUNDataBase.h"

static CGFloat const animationDuration = 1.f;

@interface RUNHomeViewController () {
    NSArray *_descs;
    NSArray *_colors;
    NSString *_stepCount;
    NSDate  *_stepDate;
    CGFloat _activityTime;
    NSInteger  _count;
    NSMutableArray *_barDatas;
    BOOL _isStartUpdate;
}

@property (nonatomic, strong) RUNCircleView                     *circleView;
@property (nonatomic, strong) YXLBaseChart                      *barChart;
@property (nonatomic, strong) RUNTimeManager                    *timeManager;
@property (nonatomic, strong) NSDate                            *currentDate;
@property (nonatomic, strong) RUNUserModel                      *userModel;
@property (nonatomic, strong) CMPedometer                       *cmPedometer;
@property (nonatomic, strong) RUNTextView                       *kcalLabel;
@property (nonatomic, strong) RUNTextView                       *timeLabel;
@property (nonatomic, strong) RUNTextView                       *disLabel;
@property (nonatomic, strong) RUNDataBase                       *dataBase;

@end

@implementation RUNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_refreshMessage) name:RUNHEADIMAGENOTIFICATION object:nil];
    
    [self p_updateDataBase];
    [self p_initilaze];
    [self p_setNavigation];
    [self p_drawCircle];
    [self p_addMessageText];
    [self p_addBarChart];
    [self p_addButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popOverWithRow:) name:RUNFUNCNOTIFICATION object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RUNFUNCNOTIFICATION object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RUNHEADIMAGENOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init
- (void)p_initilaze {
    [self.userModel loadData];
    _count = 0;
    _stepCount = @"0";
    _descs = @[@"千卡", @"活跃时间(分)", @"公里"];
    _colors = @[[UIColor colorWithRed:234 / 255.0 green:98 / 255.0 blue:86 / 255.0 alpha:1],
                [UIColor colorWithRed:245 / 255.0 green:166 / 255.0 blue:35 / 255.0 alpha:1],
                [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1]];
}

#pragma mark - Navigation Item
- (void)p_setNavigation {
    //单独设置Navigation的title
    self.navigationItem.title = [self.timeManager run_getCurrentDate];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(leftBarItemAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"round_add"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(rightBarItemAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - Draw Circle
- (void)p_drawCircle {
    self.circleView = [[RUNCircleView alloc] initWithFrame:CGRectMake(ViewWidth / 2.0 - ViewWidth / 4.2, ViewHeight / 16.0,
                                                                      ViewWidth / 2.1, ViewWidth / 2.1)];
    self.circleView.totalStep = [self.userModel.tag integerValue];
    self.circleView.animationDuration = animationDuration;
    self.circleView.nowStep = @"0";
    [self.view addSubview:self.circleView];
}

#pragma mark - Add MessageText
- (void)p_addMessageText {
    self.kcalLabel = [self p_getRunTextView];
    self.kcalLabel.title = _descs[0];
    self.kcalLabel.mainTitleColor = _colors[0];
    [self.view addSubview:self.kcalLabel];
    
    [self.kcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.bottom).offset(30);
        make.left.equalTo(self.view.left).offset(ViewWidth / 3.0 * (0 % 3));
        make.width.equalTo(ViewWidth / 3.0);
        make.height.equalTo(ViewHeight / 10.0);
    }];
    
    self.timeLabel = [self p_getRunTextView];
    self.timeLabel.title = _descs[1];
    self.timeLabel.mainTitleColor = _colors[1];
    [self.view addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.bottom).offset(30);
        make.left.equalTo(self.view.left).offset(ViewWidth / 3.0 * (1 % 3));
        make.width.equalTo(ViewWidth / 3.0);
        make.height.equalTo(ViewHeight / 10.0);
    }];
    
    self.disLabel = [self p_getRunTextView];
    self.disLabel.title = _descs[2];
    self.disLabel.mainTitleColor = _colors[2];
    self.disLabel.format = @"%.1f";
    [self.view addSubview:self.disLabel];
    
    [self.disLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.bottom).offset(30);
        make.left.equalTo(self.view.left).offset(ViewWidth / 3.0 * (2 % 3));
        make.width.equalTo(ViewWidth / 3.0);
        make.height.equalTo(ViewHeight / 10.0);
    }];
    
    [self p_startUpdateCount];

}

#pragma mark - SetBarChart
- (void)p_addBarChart {
    self.barChart = [YXLChartsFactory chartsFactory:YXLChartColumnar];
    self.barChart.bounds = CGRectMake(0, 0, ViewWidth - 50, ViewHeight / 5);
    self.barChart.animationDuration = animationDuration;
    self.barChart.lineWidth = 5.f;
    //设置柱型的渐变颜色组
    self.barChart.backgroundColors = @[(__bridge id)[UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor,
                                  (__bridge id)[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1].CGColor];
    //设置虚线颜色
    self.barChart.dashLineColor = [UIColor colorWithRed:230 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:0.6];
    self.barChart.lineColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
    self.barChart.labelColor = [UIColor lightGrayColor];
    //不使用所有的虚线
    self.barChart.showAllDashLine = NO;
    self.barChart.unit = YXLUnitDay;
    self.barChart.heightXDatas = @[@"上午12时", @"下午12时", @"上午12时"];
    self.barChart.dataArray = _barDatas;

    [self.barChart drawChart];
    [self.view addSubview:self.barChart];
    
    [self.barChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.bottom).offset(45 + ViewHeight / 10.0);
        make.left.equalTo(self.view.left).offset(25);
        make.right.equalTo(self.view.right).offset(-25);
        make.width.equalTo(ViewWidth - 50);
        make.height.equalTo(ViewHeight / 5);
    }];
}

#pragma mark - addButton
- (void)p_addButton {
    UIButton *shotScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shotScreenButton setTitle:@"SHARE" forState:UIControlStateNormal];
    shotScreenButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    [shotScreenButton setTitleColor:[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1] forState:UIControlStateNormal];
    [shotScreenButton addTarget:self action:@selector(shotScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shotScreenButton];
    
    CGFloat offset = (ViewHeight - 48 - (45 + ViewHeight / 10.0 * 3 + ViewWidth / 2.1 + ViewHeight / 16.0) - 64) / 2.0;
    CGFloat originY = offset + 45 + ViewHeight / 10.0 * 3 - 12.5;
    
    [shotScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.bottom).offset(originY);
        make.left.equalTo(self.view.left).offset(ViewWidth / 4.0 - ViewWidth / 10.0);
        make.width.equalTo(ViewWidth / 5.0);
        make.height.equalTo(25);
    }];
    
    UIButton *runButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [runButton setTitle:@"RUN" forState:UIControlStateNormal];
    runButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    [runButton setTitleColor:[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1] forState:UIControlStateNormal];
    [runButton addTarget:self action:@selector(runButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:runButton];
    
    [runButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.bottom).offset(originY);
        make.right.equalTo(self.view.right).offset(-(ViewWidth / 4.0 - ViewWidth / 10.0));
        make.width.equalTo(ViewWidth / 5.0);
        make.height.equalTo(25);
    }];
}

#pragma mark - Update Data Base
- (void)p_updateDataBase {
    if (![CMPedometer isStepCountingAvailable] || ![CMPedometer isDistanceAvailable] || ![CMPedometer isPaceAvailable]) {
        NSLog(@"CMPedometer Error");
    }
    
    __weak typeof(self) weakSelf = self;
    [self.dataBase insertDataBaseWithHandle:^(BOOL isUpdate, NSInteger count) {
        NSDate *date = [NSDate date];
        NSDate *toDate = [date dateByAddingTimeInterval:86400];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *fromStr = [[dateFormatter stringFromDate:date] stringByAppendingString:@" 00:00:00"];
        NSString *toStr = [[dateFormatter stringFromDate:toDate] stringByAppendingString:@" 00:00:00"];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        date = [dateFormatter dateFromString:fromStr];
        toDate = [dateFormatter dateFromString:toStr];
        NSArray *datas = [weakSelf.dataBase queryWithDataFromDate:date toDate:toDate];
        if (datas.count > 0 && isUpdate) {
            NSString *dateStr = [datas firstObject];
            NSArray *dateArray = [dateStr componentsSeparatedByString:@"$"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            [[NSUserDefaults standardUserDefaults] setObject:[dateFormatter dateFromString:dateArray[0]] forKey:@"oldDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [weakSelf p_fixDatas:datas];
    }];
}

#pragma mark - Start Update Count
- (void)p_startUpdateCount {
    // 启动计步
    [self.cmPedometer startPedometerUpdatesFromDate:[self stepDate] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_count == 0) {
                _activityTime = [pedometerData.averageActivePace doubleValue] / 60 * [pedometerData.distance doubleValue];
                _count++;
            }
            _isStartUpdate = YES;
            CGFloat time = [pedometerData.averageActivePace doubleValue] / 60 * [pedometerData.distance doubleValue];
            CGFloat timeValue = (time != _activityTime) ? time + _activityTime : time;
            _stepCount = [pedometerData.numberOfSteps stringValue];
            self.circleView.nowStep = [pedometerData.numberOfSteps stringValue];
            self.disLabel.mainTitle = [NSString stringWithFormat:@"%.1f", [pedometerData.distance doubleValue] / 1000];
            self.timeLabel.mainTitle = [NSString stringWithFormat:@"%.0f", timeValue];
            self.kcalLabel.mainTitle = [NSString stringWithFormat:@"%.0f", [self.userModel.weight doubleValue] *
                                        ([pedometerData.distance doubleValue] / 1000) * 1.036];
            
            [self.disLabel setLabelAnimation];
            [self.timeLabel setLabelAnimation];
            [self.kcalLabel setLabelAnimation];
        });
        
    }];
}

#pragma mark - Update Bar Data
- (void)p_fixDatas:(NSArray *)datas {
    _barDatas = nil;
    _barDatas = [NSMutableArray array];
    for (int index = 0; index < 24; index++) {
        [_barDatas addObject:@"0"];
    }
    for (NSString *obj in datas) {
        NSArray *array = [obj componentsSeparatedByString:@"$"];
        NSString *dateStr = [array firstObject];
        NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
        dataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [dataFormatter dateFromString:dateStr];
        dataFormatter.dateFormat = @"HH";
        NSString *hourStr = [dataFormatter stringFromDate:date];
        [_barDatas replaceObjectAtIndex:[hourStr integerValue] withObject:array[1]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.barChart removeFromSuperview];
        [self p_addBarChart];
    });
}

#pragma mark - Bar Item Action
- (void)leftBarItemAction:(UIBarButtonItem *)button {
    RUNCalendarViewController *caleVC = [[RUNCalendarViewController alloc] init];
    caleVC.currentDate = self.currentDate;
    __weak typeof(self) weakSelf = self;
    caleVC.calendarBlock = ^(NSString *dateMessage) {
        weakSelf.navigationItem.title = dateMessage;
        weakSelf.currentDate = [weakSelf.timeManager run_getDateFromString:dateMessage withFormatter:@"yyyy年MM月dd日"];
        [weakSelf p_changeDataWithDate:weakSelf.currentDate];
    };
    [self presentViewController:caleVC animated:YES completion:nil];
}

- (void)rightBarItemAction:(UIBarButtonItem *)button {
    RUNFuncViewController *funcVC = [[RUNFuncViewController alloc] init];
    [self presentViewController:funcVC animated:YES completion:nil];
}

#pragma mark - Button Action
- (void)shotScreenButton:(UIButton *)button {
    RUNShareViewController *shareVC = [[RUNShareViewController alloc] init];
    shareVC.imageData = [self run_getScreenShotWithSize:self.view.bounds.size view:self.view];
    [self presentViewController:shareVC animated:YES completion:nil];
}

- (void)runButton:(UIButton *)button {
    RUNMapViewController *mapVC = [[RUNMapViewController alloc] init];
    mapVC.hidesBottomBarWhenPushed = YES;
    mapVC.title = @"运动";
    [self.navigationController pushViewController:mapVC animated:YES];
}


#pragma mark - Change Data
- (void)p_changeDataWithDate:(NSDate *)nowDate {
    _count = 0;
    NSDate *current = [self.timeManager run_getDateFromString:[self.timeManager run_getCurrentDate] withFormatter:@"yyyy年MM月dd日"];
    NSDate *toDate = [nowDate dateByAddingTimeInterval:86400];
    NSArray *datas = [self.dataBase queryWithDataFromDate:nowDate toDate:toDate];
    
    if (![nowDate isEqualToDate:current]) {
        [self.cmPedometer stopPedometerUpdates];
        [self p_detailDataWithCircleView:datas isCurrentData:NO];
    } else {
        [self p_detailDataWithCircleView:datas isCurrentData:YES];
        [self p_startUpdateCount];
    }
    [self p_fixDatas:datas];
    
}

- (void)p_detailDataWithCircleView:(NSArray *)datas isCurrentData:(BOOL)isCurrent {
    if ((isCurrent == YES) && (_isStartUpdate == YES)) {
        return ;
    }
    NSMutableArray *messArray = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @""]];
    for (NSString *obj in datas) {
        NSArray *array = [obj componentsSeparatedByString:@"$"];
        [messArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%.0f", [array[1] doubleValue] + [messArray[0] doubleValue]]];
        [messArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%.0f", [array[2] doubleValue] + [messArray[1] doubleValue]]];
        [messArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%.0f", [array[3] doubleValue] + [messArray[2] doubleValue]]];
        [messArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%.1f", [array[4] doubleValue] + [messArray[3] doubleValue]]];
    }
    self.circleView.nowStep = messArray[0];
    self.kcalLabel.mainTitle = messArray[1];
    self.timeLabel.mainTitle = messArray[2];
    self.disLabel.mainTitle = [NSString stringWithFormat:@"%.1f", [messArray[3] doubleValue] / 1000];
    [self.disLabel setLabelAnimation];
    [self.timeLabel setLabelAnimation];
    [self.kcalLabel setLabelAnimation];
}

#pragma mark - NSNotification Action
- (void)popOverWithRow:(id)sender{
    NSInteger row = [[[sender userInfo] objectForKey:@"row"] integerValue];
    NSLog(@"%ld", (long)row);
    if (row == 0) {
        RUNMapViewController *mapVC = [[RUNMapViewController alloc] init];
        mapVC.hidesBottomBarWhenPushed = YES;
        mapVC.title = @"运动";
        [self.navigationController pushViewController:mapVC animated:YES];
    } else if (row == 2) {
        RUNFAQViewController *faqVC = [[RUNFAQViewController alloc] init];
        faqVC.title = @"帮助";
        faqVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:faqVC animated:YES];
    } else if (row == 1) {
        RUNWeightViewController *weight = [[RUNWeightViewController alloc] init];
        weight.title = @"录入体重";
        weight.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:weight animated:YES];
    }
}

- (void)p_refreshMessage {
    [self.userModel loadData];
    self.circleView.totalStep = [self.userModel.tag integerValue];
    self.circleView.nowStep = _stepCount;
    [self.cmPedometer stopPedometerUpdates];
    [self p_startUpdateCount];
}

#pragma mark - Lazy Method
- (NSDate *)currentDate {
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}

- (RUNTimeManager *)timeManager {
    if (!_timeManager) {
        _timeManager = [[RUNTimeManager alloc] init];
    }
    return _timeManager;
}

- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
    }
    return _userModel;
}

- (NSDate *)stepDate {
    if (!_stepDate) {
        NSDate *toDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _stepDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]];
    }
    return _stepDate;
}

- (RUNDataBase *)dataBase {
    if (!_dataBase) {
        _dataBase = [[RUNDataBase alloc] init];
    }
    return _dataBase;
}

- (CMPedometer *)cmPedometer {
    if (!_cmPedometer) {
        _cmPedometer = [[CMPedometer alloc] init];
    }
    return _cmPedometer;
}

- (RUNTextView *)p_getRunTextView {
    RUNTextView *energyView = [[RUNTextView alloc] initWithFrame:CGRectZero];
    energyView.mainTitle = @"0";
    energyView.mainTitleFont = [UIFont fontWithName:@"Helvetica" size:ViewHeight / 20.f];
    energyView.titleFont = [UIFont systemFontOfSize:12.f];
    energyView.animationDuration = animationDuration;
    energyView.titleColor = [UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:1];
    energyView.format = @"%d";
    
    return energyView;
}

@end
