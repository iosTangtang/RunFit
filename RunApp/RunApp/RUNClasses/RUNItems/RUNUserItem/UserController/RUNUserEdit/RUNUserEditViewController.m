//
//  RUNUserEditViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNUserEditViewController.h"
#import "RunUserTableViewCell.h"
#import "RUNPickViewController.h"
#import "SVProgressHUD.h"
#import "RUNUserModel.h"
#import "RUNHistoryModel.h"

static NSString *const kNormalCell = @"RUNUserNormalCell";

@interface RUNUserEditViewController () <UITableViewDelegate, UITableViewDataSource, RUNPickerViewDelegate> {
    NSInteger _row;
}

@property (nonatomic, strong)   UITableView         *tableView;
@property (nonatomic, copy)     NSArray             *titles;
@property (nonatomic, strong)   NSMutableArray      *datas;
@property (nonatomic, strong)   NSMutableArray      *stands;
@property (nonatomic, strong)   RUNUserModel        *userModel;

@end

@implementation RUNUserEditViewController

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"性别", @"体重", @"身高", @"我的步数目标"];
    }
    return _titles;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] initWithArray:@[self.userModel.sex, self.userModel.weight, self.userModel.height, self.userModel.tag]];
    }
    return _datas;
}

- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}

- (NSMutableArray *)stands {
    if (!_stands) {
        NSMutableArray *weight1 = [NSMutableArray array];
        NSMutableArray *weight2 = [NSMutableArray array];
        NSMutableArray *height = [NSMutableArray array];
        NSMutableArray *tags = [NSMutableArray array];
        for (int index = 50; index < 251; index++) {
            [height addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 25; index < 251; index++) {
            [weight1 addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 0; index < 10; index++) {
            [weight2 addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 1000; index < 21000; index += 1000) {
            [tags addObject:[NSString stringWithFormat:@"%d", index]];
        }
        _stands = [[NSMutableArray alloc] initWithObjects:@[@[@"男", @"女"]], @[weight1, weight2, @[@"kg"]], @[height, @[@"cm"]], @[tags], nil];
    }
    return _stands;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setNavigationItem];
    [self p_setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Item
- (void)p_setNavigationItem {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(p_overAction:)];
    self.navigationItem.rightBarButtonItem = right;
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RunUserTableViewCell *cell = [RunUserTableViewCell cellWith:tableView identifity:kNormalCell];
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.valueLabel.text = self.datas[indexPath.row];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _row = indexPath.row;
    [self p_initPickerView:indexPath.row];
    return;
    
}

- (void)p_initPickerView:(NSUInteger)row {
    RUNPickViewController *pick = [[RUNPickViewController alloc] init];
    pick.pickDelegate = self;
    pick.backGroundColor = [UIColor whiteColor];
    pick.datas = self.stands[row];
    pick.mainTitle = self.titles[row];
    pick.separator = @".";
    if (row == 0) {
        NSString *value = @"0";
        if ([self.userModel.sex isEqualToString:@"女"]) {
            value = @"1";
        }
        pick.defaultData = @[value];
        pick.dValue = @[@"0"];
    } else if (row == 1) {
        NSString *weight = [[self.userModel.weight componentsSeparatedByString:@"kg"] firstObject];
        pick.defaultData = [weight componentsSeparatedByString:@"."];
        pick.dValue = @[@"25", @"0"];
    } else if (row == 2) {
        NSString *height = [[self.userModel.height componentsSeparatedByString:@"c"] firstObject];
        pick.defaultData = @[height];
        pick.dValue = @[@"50"];
    }
    
    pick.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:pick animated:YES completion:nil];
}

#pragma mark - RUNPickerViewDelegate
- (void)pickText:(NSString *)text {
    [self.datas replaceObjectAtIndex:_row withObject:text];
    [self.tableView reloadData];
}

#pragma mark - Over Action
- (void)p_overAction:(UIBarButtonItem *)barButton {
    [SVProgressHUD showWithStatus:@"保存中.."];
    self.userModel.sex = self.datas[0];
    self.userModel.weight = self.datas[1];
    self.userModel.height = self.datas[2];
    self.userModel.tag = self.datas[3];
    [self.userModel saveData];
    [self p_saveData];
}

#pragma mark - Save Method
- (void)p_saveData {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeDate = [dateFormatter stringFromDate:[NSDate date]];
    __weak typeof(self) weakSelf = self;
    RUNHistoryModel *model = [[RUNHistoryModel alloc] init];
    model.type = @"humanWeight";
    model.date = timeDate;
    model.duration = @"0";
    model.value = [weakSelf.datas[1] doubleValue];
    model.speed = 0;
    model.step = 0;
    model.kcal = 0;
    model.points = @[@"0"];
    [model saveDataWithHandle:^(BOOL isSucceed) {
        if (isSucceed) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:RUNHEADIMAGENOTIFICATION object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
    }];
}

@end
