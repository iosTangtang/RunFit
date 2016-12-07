//
//  RUNWeightViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNWeightViewController.h"
#import "RUNPickViewController.h"
#import "RunUserTableViewCell.h"
#import "RUNTimeManager.h"
#import "SVProgressHUD.h"
#import "RUNUserModel.h"

static NSString *const identifity = @"RUNWeightViewController";

@interface RUNWeightViewController () <UITableViewDelegate, UITableViewDataSource, RUNPickerViewDelegate>

@property (nonatomic, strong) RUNUserModel      *userModel;
@property (nonatomic, copy)   NSArray           *datas;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, copy)   NSArray           *titles;
@property (nonatomic, copy)   NSMutableArray    *values;
@property (nonatomic, copy)   NSString          *weightText;
@property (nonatomic, copy)   NSString          *dateText;
@property (nonatomic, copy)   NSString          *timeText;

@end

@implementation RUNWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setNavigationItem];
    [self p_setupTableView];
}

#pragma mark - Navigation Item
- (void)p_setNavigationItem {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(p_overAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - Over Action
- (void)p_overAction:(UIBarButtonItem *)barButton {
    RUNTimeManager *manager = [[RUNTimeManager alloc] init];
    if (!self.weightText || !self.dateText) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (![self.dateText isEqualToString:[manager run_getCurrentDate]] ||
        ![self.timeText isEqualToString:[manager run_getCurrentDateWithFormatter:@"a HH:mm"]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [SVProgressHUD showWithStatus:@"保存中.."];
    self.userModel.weight = self.weightText;
    [self.userModel saveData];
    [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    [[NSNotificationCenter defaultCenter] postNotificationName:RUNUSERNOTIFICATION object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Set TableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifity];
        cell.textLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.detailTextLabel.text = self.values[indexPath.row];
    
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RUNTimeManager *manager = [[RUNTimeManager alloc] init];
    
    RUNPickViewController *pick = [[RUNPickViewController alloc] init];
    pick.pickDelegate = self;
    pick.backGroundColor = [UIColor whiteColor];
    pick.row = indexPath.row;
    pick.datas = self.datas[indexPath.row];
    pick.mainTitle = self.titles[indexPath.row];
    if (indexPath.row == 0) {
        pick.separator = @"";
        pick.defaultData = @[[manager run_getCurrentDateWithFormatter:@"yyyy"],
                             [manager run_getCurrentDateWithFormatter:@"MM"],
                             [manager run_getCurrentDateWithFormatter:@"dd"]];
        pick.dValue = @[@"1000", @"1", @"1"];
    } else if(indexPath.row == 1) {
        pick.separator = @" ";
        pick.isTime = YES;
        NSString *value;
        if ([[manager run_getCurrentDateWithFormatter:@"a"] isEqualToString:@"AM"]) {
            value = @"0";
        } else {
            value = @"1";
        }
        pick.defaultData = @[value,[manager run_getCurrentDateWithFormatter:@"HH"],
                             [manager run_getCurrentDateWithFormatter:@"mm"]];
        pick.dValue = @[@"0", @"1", @"0"];
    } else {
        pick.separator = @".";
        NSString *weight = [[self.userModel.weight componentsSeparatedByString:@"kg"] firstObject];
        pick.defaultData = [weight componentsSeparatedByString:@"."];
        pick.dValue = @[@"25", @"0"];
    }
    pick.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:pick animated:YES completion:nil];
}

#pragma mark - RUNPickerView Delegate
- (void)pickText:(NSString *)text withRow:(NSUInteger)row {
    NSLog(@"%lu", (unsigned long)row);
    if (row == 2) {
        self.weightText = text;
        [self.values replaceObjectAtIndex:row withObject:self.weightText];
    } else if (row == 0){
        self.dateText = text;
        [self.values replaceObjectAtIndex:row withObject:self.dateText];
    } else {
        self.timeText = text;
        [self.values replaceObjectAtIndex:row withObject:self.timeText];
    }
    [self.tableView reloadData];
}

#pragma mark - Set Method
- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}

- (NSArray *)datas {
    if (!_datas) {
        NSMutableArray *weight1 = [NSMutableArray array];
        NSMutableArray *weight2 = [NSMutableArray array];
        NSMutableArray *years = [NSMutableArray array];
        NSMutableArray *months = [NSMutableArray array];
        NSMutableArray *days = [NSMutableArray array];
        NSMutableArray *hours = [NSMutableArray array];
        NSMutableArray *mins = [NSMutableArray array];
        for (int index = 25; index < 251; index++) {
            [weight1 addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 0; index < 10; index++) {
            [weight2 addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 1000; index < 3000; index++) {
            [years addObject:[NSString stringWithFormat:@"%d年", index]];
        }
        for (int index = 1; index < 13; index++) {
            [months addObject:[NSString stringWithFormat:@"%d月", index]];
        }
        for (int index = 1; index < 32; index++) {
            [days addObject:[NSString stringWithFormat:@"%d日", index]];
        }
        for (int index = 1; index < 25; index++) {
            [hours addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 0; index < 60; index++) {
            if (index < 10) {
                [mins addObject:[NSString stringWithFormat:@"0%d", index]];
            } else {
                [mins addObject:[NSString stringWithFormat:@"%d", index]];
            }
            
        }
        _datas = @[@[years, months, days], @[@[@"AM", @"PM"], hours, mins], @[weight1, weight2, @[@"kg"]]];
    }
    return _datas;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"日期", @"时间", @"体重"];
    }
    return _titles;
}

- (NSMutableArray *)values {
    if (!_values) {
        RUNTimeManager *manager = [[RUNTimeManager alloc] init];
        NSString *str1 = [manager run_getCurrentDate];
        NSString *str2 = [manager run_getCurrentDateWithFormatter:@"a HH:mm"];
        NSString *str3 = self.userModel.weight;
        _values = [NSMutableArray arrayWithArray:@[str1, str2, str3]];
    }
    return _values;
}

- (NSString *)weightText {
    if (!_weightText) {
        _weightText = self.userModel.weight;
    }
    return _weightText;
}

- (NSString *)dateText {
    if (!_dateText) {
        RUNTimeManager *manager = [[RUNTimeManager alloc] init];
        _dateText = [manager run_getCurrentDate];
    }
    return _dateText;
}

- (NSString *)timeText {
    if (!_timeText) {
        RUNTimeManager *manager = [[RUNTimeManager alloc] init];
        _timeText = [manager run_getCurrentDateWithFormatter:@"a HH:mm"];
    }
    return _timeText;
}

@end
