//
//  RUNAllDataViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/16.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNAllDataViewController.h"

static NSString *const identifity = @"RUNAllDataViewController";

@interface RUNAllDataViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)   UITableView         *tableView;

@end

@implementation RUNAllDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Set TableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] init];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifity];
        cell.textLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
    }
    
    NSDictionary *dic = self.dataArray[self.dataArray.count - indexPath.row - 1];
    NSNumber *number = dic[@"value"];
    cell.textLabel.text = [NSString stringWithFormat:@"%.1f %@", [number doubleValue], self.unit];
    cell.detailTextLabel.text = dic[@"date"];

    if ([self.unit isEqualToString:@"公里"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%.1f %@", [number doubleValue] / 1000, self.unit];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
