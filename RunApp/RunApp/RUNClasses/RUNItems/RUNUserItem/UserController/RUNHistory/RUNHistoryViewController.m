//
//  RUNHistoryViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNHistoryViewController.h"
#import "RUNHistoryTableViewCell.h"
#import "RUNHistoryMapViewController.h"

static NSString *const  kRUNIdentifity = @"RUNHistoryCell";
static NSString *const  kWeightIdentifity = @"RUNWeightCell";

@interface RUNHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)   UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray  *datas;

@end

@implementation RUNHistoryViewController

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] initWithArray:@[@{@"run" : @"10公里", @"duration" : @"10分钟", @"kcal" : @"299大卡", @"numbers" : @"2999步",
                                                           @"time" : @"2016年11月4日 PM 10:22", @"type" : @"run"},
                                                         @{@"run" : @"12公里", @"duration" : @"30分钟", @"kcal" : @"399大卡", @"numbers" : @"5999步",
                                                           @"time" : @"2016年11月14日 PM 10:22", @"type" : @"run"},
                                                         @{@"weight" : @"56.6kg", @"time" : @"2016年11月16日 PM 10:22", @"type" : @"weight"}]];
    }
    return _datas;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self p_setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RUNHistoryTableViewCell *cell = nil;
    NSDictionary *dic = self.datas[indexPath.row];
    if ([dic[@"type"] isEqualToString:@"run"]) {
        cell = [RUNHistoryTableViewCell cellWith:tableView identifity:kRUNIdentifity];
        cell.runLabel.text = dic[@"run"];
        cell.durationLabel.text = dic[@"duration"];
        cell.kcalLabel.text = dic[@"kcal"];
        cell.numbersLabel.text = dic[@"numbers"];
    } else {
        cell = [RUNHistoryTableViewCell cellWith:tableView identifity:kWeightIdentifity];
        cell.runLabel.text = dic[@"weight"];
    }
    
    cell.timeLabel.text = dic[@"time"];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.datas[indexPath.row];
    if ([dic[@"type"] isEqualToString:@"run"]) {
        return 136.5;
    }
    return 70.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.datas[indexPath.row];
    if ([dic[@"type"] isEqualToString:@"weight"]) {
        return ;
    }
    RUNHistoryMapViewController *hisMapVC = [[RUNHistoryMapViewController alloc] init];
    [self.navigationController pushViewController:hisMapVC animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否删除？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.datas removeObjectAtIndex:indexPath.row];
        NSArray *deleteItems = @[indexPath];
        [weakSelf.tableView deleteRowsAtIndexPaths:deleteItems withRowAnimation:UITableViewRowAnimationMiddle];
    }];
    [alert addAction:yesAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
