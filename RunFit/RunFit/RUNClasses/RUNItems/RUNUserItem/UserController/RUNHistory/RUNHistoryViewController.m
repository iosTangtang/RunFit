//
//  RUNHistoryViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNHistoryViewController.h"
#import "RUNHistoryTableViewCell.h"
#import "RUNHistoryModel.h"
#import "RUNHistoryMapViewController.h"
#import "SVProgressHUD.h"
#import "RUNDataBase.h"
#import "MJRefresh.h"

static NSString *const  kRUNIdentifity = @"RUNHistoryCell";
static NSString *const  kWeightIdentifity = @"RUNWeightCell";
static NSInteger const  kPageNumber = 20;

@interface RUNHistoryViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger _nowNumber;
}

@property (nonatomic, strong)   UITableView             *tableView;
@property (nonatomic, strong)   NSMutableArray          *filePaths;
@property (nonatomic, strong)   NSMutableArray          *datas;
@property (nonatomic, strong)   RUNDataBase             *dataBase;

@end

@implementation RUNHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_loadFileData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load File Data
- (void)p_loadFileData {
    [SVProgressHUD showWithStatus:@"读取数据中"];
    _nowNumber = 0;
    
    NSArray *dataArray = [self.dataBase queryDataWithLimitNumber:_nowNumber pagesNumber:kPageNumber];
    for (NSDictionary *dic in dataArray) {
        RUNHistoryModel *model = [[RUNHistoryModel alloc] init];
        [model dicToModel:dic];
        [self.datas addObject:model];
    }
    _nowNumber = kPageNumber + 1;
    
    [SVProgressHUD dismiss];
    [self p_setupTableView];
}

#pragma mark - Set TableView 
- (void)p_setupTableView {
    if (self.datas.count == 0) {
        [self p_setNoMessageView];
        return ;
    }
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSArray *array = [self.dataBase queryDataWithLimitNumber:_nowNumber pagesNumber:kPageNumber];
        for (NSDictionary *dic in array) {
            RUNHistoryModel *model = [[RUNHistoryModel alloc] init];
            [model dicToModel:dic];
            [self.datas addObject:model];
        }
        _nowNumber = _nowNumber + 1;
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)p_setNoMessageView {
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = @"暂无数据";
    messageLabel.font = [UIFont systemFontOfSize:25.f];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:messageLabel];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.bounds.size.width / 2.0);
        make.height.equalTo(100);
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY);
    }];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RUNHistoryTableViewCell *cell = nil;
    RUNHistoryModel *model = self.datas[indexPath.row];
    if (![model.type isEqualToString:@"humanWeight"]) {
        cell = [RUNHistoryTableViewCell cellWith:tableView identifity:kRUNIdentifity];
        cell.runLabel.text = [NSString stringWithFormat:@"%.1f 公里", model.value];
        cell.durationLabel.text = [NSString stringWithFormat:@"%@ 分钟", model.duration];
        NSArray *array = [model.duration componentsSeparatedByString:@":"];
        if (array.count > 1) {
            CGFloat duration = [array[0] doubleValue] + ([array[1] doubleValue] / 60);
            cell.durationLabel.text = [NSString stringWithFormat:@"%.1f 分钟", duration];
        }
        
        cell.kcalLabel.text = [NSString stringWithFormat:@"%.0f 大卡", model.kcal];
        cell.numbersLabel.text = [NSString stringWithFormat:@"%.0f 步", model.step];
        if ([model.type isEqualToString:@"bike"]) {
            cell.numbersLabel.text = [NSString stringWithFormat:@"%.1f s/m", model.speed];
        }
        
    } else {
        cell = [RUNHistoryTableViewCell cellWith:tableView identifity:kWeightIdentifity];
        cell.runLabel.text = [NSString stringWithFormat:@"%.1f kg", model.value];
    }
    
    cell.timeLabel.text = model.date;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RUNHistoryModel *model = self.datas[indexPath.row];
    if (![model.type isEqualToString:@"humanWeight"]) {
        return 136.5;
    }
    return 70.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RUNHistoryModel *model = self.datas[indexPath.row];
    if ([model.type isEqualToString:@"humanWeight"]) {
        return ;
    }
    RUNHistoryMapViewController *hisMapVC = [[RUNHistoryMapViewController alloc] init];
    hisMapVC.isToRoot = NO;
    hisMapVC.isRun = ([model.type isEqualToString:@"bike"] == 0) ? YES : NO;
    hisMapVC.datas = @[model.duration, [NSString stringWithFormat:@"%.0f", model.value],
                                        [NSString stringWithFormat:@"%.0f", model.kcal],
                                        [NSString stringWithFormat:@"%.0f", model.step]];
    if ([model.type isEqualToString:@"bike"]) {
        hisMapVC.datas = @[model.duration, [NSString stringWithFormat:@"%.0f", model.value],
                                            [NSString stringWithFormat:@"%.0f", model.kcal],
                                            [NSString stringWithFormat:@"%.1f", model.speed]];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:MM:ss";
    hisMapVC.dateTitle = model.date;
    hisMapVC.lineDatas = model.points;
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
        NSError *error = nil;
        NSString *filePath = weakSelf.filePaths[indexPath.row];
        [weakSelf.filePaths removeObjectAtIndex:indexPath.row];
        [weakSelf.datas removeObjectAtIndex:indexPath.row];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:&error];
        NSArray *deleteItems = @[indexPath];
        [weakSelf.tableView deleteRowsAtIndexPaths:deleteItems withRowAnimation:UITableViewRowAnimationMiddle];
        if (weakSelf.datas.count == 0) {
            [weakSelf.tableView removeFromSuperview];
            [weakSelf p_setNoMessageView];
        }
        
    }];
    [alert addAction:yesAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSMutableArray *)filePaths {
    if (!_filePaths) {
        _filePaths = [NSMutableArray array];
    }
    return _filePaths;
}

- (RUNDataBase *)dataBase {
    if (!_dataBase) {
        _dataBase = [[RUNDataBase alloc] init];
    }
    return _dataBase;
}

@end
