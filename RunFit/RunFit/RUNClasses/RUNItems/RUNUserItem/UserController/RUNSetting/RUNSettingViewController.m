//
//  RUNSettingViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNSettingViewController.h"
#import "RUNSettingTableViewCell.h"
#import "RUNFAQViewController.h"
#import "RUNFeedBackViewController.h"
#import "RUNUserModel.h"

static NSString *const  kIdentifity = @"RUNSETTING";
static NSString *const  kCellIdentifity = @"RUNSETTINGNORMAL";

@interface RUNSettingViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger _count;
}

@property (nonatomic, strong)   UITableView     *tableView;
@property (nonatomic, copy)     NSArray         *datas;

@end

@implementation RUNSettingViewController

- (NSArray *)datas {
    if (!_datas) {
        _datas = @[@"帮助", @"意见反馈", @"分享"];
    }
    return _datas;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    RUNUserModel *userModel = [[RUNUserModel alloc] init];
    [userModel loadData];
    if (userModel.isLogin) {
        _count = 1;
    } else {
        _count = 0;
    }
    
    [self p_setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set TableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.sectionFooterHeight = 5.f;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifity];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RUNSettingTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:kIdentifity];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.datas.count;
    }
    return _count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        RUNSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifity];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifity];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.datas[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self p_userExit];
    } else {
        switch (indexPath.row) {
            case 0: {
                RUNFAQViewController *faqVC = [[RUNFAQViewController alloc] init];
                faqVC.title = @"帮助";
                [self.navigationController pushViewController:faqVC animated:YES];
                break;
            }
            case 1: {
                RUNFeedBackViewController *feedVC = [[RUNFeedBackViewController alloc] init];
                feedVC.title = @"意见反馈";
                [self.navigationController pushViewController:feedVC animated:YES];
                break;
            }
            case 2: {
                NSURL *imageUrl = [[NSURL alloc] initWithString:@"https://www.baidu.com"];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[imageUrl] applicationActivities:nil];
                [self presentViewController:activityVC animated:YES completion:nil];
            }
            
            default:
                break;
        }
    }
}

#pragma mark - User Exit Action 
- (void)p_userExit {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否退出？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (_count == 1) {
            _count--;
        } else {
            _count++;
        }
        [weakSelf.tableView reloadData];
        [weakSelf p_changStatus];
    }];
    [alert addAction:yesAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)p_changStatus {
    RUNUserModel *userModel = [[RUNUserModel alloc] init];
    [userModel loadData];
    userModel.isLogin = @"NO";
    userModel.name = nil;
    [userModel saveLoginStatus];
    [userModel saveData];
    [[NSNotificationCenter defaultCenter] postNotificationName:RUNHEADIMAGENOTIFICATION object:nil];
}

@end
