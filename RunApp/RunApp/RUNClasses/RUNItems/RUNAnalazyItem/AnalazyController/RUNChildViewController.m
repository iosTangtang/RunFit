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
#import "RUNAllDataViewController.h"

static CGFloat const animationDuration = 1.f;
static CGFloat const barChartLineWidth = 8.f;
static CGFloat const lineChartLineWidth = 6.f;

@interface RUNChildViewController ()

@property (nonatomic, strong) UISegmentedControl        *segmented;
@property (nonatomic, strong) YXLBaseChart              *barChart;
@property (nonatomic, strong) UILabel                   *aver;
@property (nonatomic, strong) UILabel                   *total;

@end

@implementation RUNChildViewController

- (UILabel *)aver {
    if (!_aver) {
        _aver = [[UILabel alloc] init];
        _aver.text = @"9584 步";
        _aver.textColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
        [self.view addSubview:_aver];
    }
    return _aver;
}

- (UILabel *)total {
    if (!_total) {
        _total = [[UILabel alloc] init];
        _total.text = @"67085 步";
        _total.textColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
        [self.view addSubview:_total];
    }
    return _total;
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
        _barChart.heightXDatas = @[@"上午12时", @"下午12时", @"上午12时"];
        _barChart.dataArray = @[@"0", @"0", @"0", @"0", @"16532", @"0",@"11111", @"0", @"9876", @"10870", @"11432", @"12555",
                                @"11823", @"12345", @"3582", @"4987", @"16532", @"17982",@"11111", @"2345", @"0", @"0", @"0", @"0"];
        
    }
    return _barChart;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupSegmented];
    [self p_setChartView];
    [self p_setAllDataButton];
    [self p_label];
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
    
    self.aver.text = self.averValue;
    [self.aver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(averLabel.right).offset(20);
        make.top.equalTo(averLabel.top);
        make.width.equalTo(ViewWidth / 3 * 2);
        make.height.equalTo(20);
    }];
    
    self.total.text = self.totalValue;
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
    [self.barChart removeFromSuperview];
    self.barChart = nil;
    switch (segment.selectedSegmentIndex) {
        case 0:
            self.barChart.unit = YXLUnitDay;
            self.barChart.heightXDatas = @[@"上午12时", @"下午12时", @"上午12时"];
            self.barChart.dataArray = @[@"0", @"0", @"0", @"0", @"16532", @"0",@"11111", @"0", @"9876", @"10870", @"11432", @"12555",
                                    @"11823", @"12345", @"3582", @"4987", @"16532", @"17982",@"11111", @"2345", @"0", @"0", @"0", @"0"];
            break;
        case 1:
            self.barChart.unit = YXLUnitWeak;
            self.barChart.heightXDatas = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
            self.barChart.dataArray = @[@"11823", @"12345", @"3582", @"4987", @"11111", @"16532", @"9876"];
            break;
        case 2:
            self.barChart.unit = YXLUnitMonth;
            self.barChart.heightXDatas = @[@"10月19日", @"26", @"11月2日", @"9", @"16"];
            self.barChart.dataArray = @[@"11823", @"12345", @"3582", @"4987", @"11111", @"16532", @"9876",
                                        @"11823", @"12345", @"3582", @"4987", @"11111", @"16532", @"9876",
                                        @"11823", @"12345", @"3582", @"4987", @"11111", @"16532", @"9876",
                                        @"11823", @"12345", @"3582", @"4987", @"11111", @"16532", @"9876",
                                        @"11823", @"12345", @"12345"];
            break;
        case 3:
            self.barChart.unit = YXLUnitMonth;
            self.barChart.heightXDatas = @[@"2016年2月", @"5月", @"8月", @"11月"];
            self.barChart.dataArray = @[@"11823", @"12345", @"3582", @"4987", @"11111", @"16532", @"9876",
                                        @"11823", @"12345", @"3582", @"4987", @"11111"];
            break;
            
        default:
            break;
    }
    [self p_setChartView];
}

#pragma mark - All Data Button Action
- (void)p_allDataButtonAction:(UIButton *)button {
    RUNAllDataViewController *allDataVC = [[RUNAllDataViewController alloc] init];
    allDataVC.title = @"所有数据";
    allDataVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allDataVC animated:YES];
}

@end
