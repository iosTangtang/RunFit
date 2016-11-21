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

static CGFloat const animationDuration = 1.f;

@interface RUNHomeViewController () {
    NSArray *_descs;
    NSArray *_colors;
}

@property (nonatomic, strong) RUNCircleView                     *circleView;
@property (nonatomic, strong) YXLBaseChart                      *barChart;
@property (nonatomic, strong) NSDate                            *currentDate;
@property (nonatomic, strong) NSMutableArray                    *datas;

@end

@implementation RUNHomeViewController

// 获取当地的Date
- (NSDate *)currentDate {
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] initWithArray:@[@"147", @"82", @"3.2"]];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Init
- (void)p_initilaze {
    _descs = @[@"千卡", @"活跃时间(分)", @"公里"];
    _colors = @[[UIColor colorWithRed:234 / 255.0 green:98 / 255.0 blue:86 / 255.0 alpha:1],
                [UIColor colorWithRed:245 / 255.0 green:166 / 255.0 blue:35 / 255.0 alpha:1],
                [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1]];
}

#pragma mark - Navigation Item
- (void)p_setNavigation {
    //单独设置Navigation的title
    self.navigationItem.title = [self p_stringFromDate:self.currentDate];
    
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
    self.circleView = [[RUNCircleView alloc] initWithFrame:CGRectZero];
    self.circleView.totalStep = 10000;
    self.circleView.nowStep = 8924;
    self.circleView.animationDuration = animationDuration;
    self.circleView.bounds = CGRectMake(0, 0, ViewWidth / 2.1, ViewWidth / 2.1);
    
    [self.view addSubview:self.circleView];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(ViewHeight / 16.0);
        make.width.height.equalTo(ViewWidth / 2.1);
    }];
    
    [self.circleView drawCircle];
}

#pragma mark - Add MessageText
- (void)p_addMessageText {
    
    for (int index = 0; index < 3; index++) {
        RUNTextView *energyView = [[RUNTextView alloc] initWithFrame:CGRectZero];
        energyView.mainTitle = self.datas[index];
        energyView.title = _descs[index];
        energyView.mainTitleFont = [UIFont fontWithName:@"Helvetica" size:ViewHeight / 20.f];
        energyView.titleFont = [UIFont systemFontOfSize:12.f];
        energyView.animationDuration = animationDuration;
        energyView.mainTitleColor = _colors[index];
        energyView.titleColor = [UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:1];
        energyView.format = @"%d";
        if (index == 2) {
            energyView.format = @"%.1f";
        }
        [self.view addSubview:energyView];
        
        [energyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.circleView.bottom).offset(30);
            make.left.equalTo(self.view.left).offset(ViewWidth / 3.0 * (index % 3));
            make.width.equalTo(ViewWidth / 3.0);
            make.height.equalTo(ViewHeight / 10.0);
        }];
        [energyView setLabelAnimation];
    }
    
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
    self.barChart.heightXDatas = @[@"上午12时", @"下午12时", @"上午12时"];
    self.barChart.dataArray = @[@"0", @"0", @"0", @"0", @"16532", @"0",@"11111", @"0", @"9876", @"10870", @"11432", @"12555",
                           @"11823", @"12345", @"3582", @"4987", @"16532", @"17982",@"11111", @"2345", @"0", @"0", @"0", @"0"];
    
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

#pragma mark - Bar Item Action
- (void)leftBarItemAction:(UIBarButtonItem *)button {
    RUNCalendarViewController *caleVC = [[RUNCalendarViewController alloc] init];
    caleVC.currentDate = self.currentDate;
    __weak typeof(self) weakSelf = self;
    caleVC.calendarBlock = ^(NSString *dateMessage) {
        weakSelf.navigationItem.title = dateMessage;
        weakSelf.currentDate = [weakSelf p_dateFromString:dateMessage];
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

#pragma mark - NSNotification Action
- (void)popOverWithRow:(id)sender{
    NSInteger row = [[[sender userInfo] objectForKey:@"row"] integerValue];
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

#pragma mark - DateFormater
- (NSString *)p_stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    return [formatter stringFromDate:date];
}

- (NSDate *)p_dateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    return [formatter dateFromString:string];
}

@end
