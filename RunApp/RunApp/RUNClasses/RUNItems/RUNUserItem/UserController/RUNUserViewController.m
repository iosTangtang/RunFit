//
//  RUNUserViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/7.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNUserViewController.h"
#import "RUNUserEditViewController.h"
#import "RUNLockViewController.h"
#import "RUNHistoryViewController.h"
#import "RUNSettingViewController.h"
#import "RUNUserHeadView.h"
#import "RUNButton.h"
#import "RUNUserModel.h"

@interface RUNUserViewController ()

@property (nonatomic, strong) RUNUserHeadView   *userHead;
@property (nonatomic, copy)   NSArray           *images;
@property (nonatomic, copy)   NSArray           *titles;
@property (nonatomic, strong) RUNUserHeadView   *headView;
@property (nonatomic, strong) RUNUserModel      *userModel;

@end

@implementation RUNUserViewController

- (NSArray *)images {
    if (!_images) {
        _images = @[@"userEdit", @"lock", @"history", @"set"];
    }
    return _images;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"个人资料", @"权限中心", @"历史记录", @"设置"];
    }
    return _titles;
}

- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_refreshImage) name:RUNHEADIMAGENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_reloadUserMessage) name:RUNUSERNOTIFICATION object:nil];
    
    [self p_setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI Method
- (void)p_setUI {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults objectForKey:@"userIcon"];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image == nil) {
        image = [UIImage imageNamed:@"Oval 3"];
    }
    
    self.headView = [[RUNUserHeadView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight / 2.0)];
    [self.headView setUserName:self.userModel.name];
    [self.headView setUserImage:image];
    [self.headView setUserHeight:[self.userModel.height doubleValue]];
    [self.headView setUserWeight:[self.userModel.weight doubleValue]];
    [self.headView setUserBMI:23.9];
    [self.headView setUserTarget:[self.userModel.tag integerValue]];
    [self.view addSubview:self.headView];
    
    for (int index = 0; index < self.images.count; index++) {
        RUNButton *button = [[RUNButton alloc] initWithFrame:CGRectZero];
        button.tag = index + 1001;
        button.image = [UIImage imageNamed:self.images[index]];
        button.descStr = self.titles[index];
        __weak typeof(self) weakSelf = self;
        button.buttonAction = ^(void) {
            [weakSelf p_RUNButtonAction:index + 1001];
        };
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView.bottom).offset(ViewHeight / 15 + (ViewHeight / 6 * (index / 3)));
            make.left.equalTo(self.view.left).offset(ViewWidth / 3.0 * (index % 3));
            make.width.equalTo(ViewWidth / 3.0);
            make.height.equalTo(ViewHeight / 8);
        }];
    }
}

- (void)p_RUNButtonAction:(NSInteger)tag {
    NSInteger row = tag - 1001;
    switch (row) {
        case 0: {
            RUNUserEditViewController *userEdit = [[RUNUserEditViewController alloc] init];
            userEdit.title = @"个人资料";
            userEdit.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userEdit animated:YES];
            break;
        }
        case 1: {
            RUNLockViewController *lockVC = [[RUNLockViewController alloc] init];
            lockVC.title = @"权限中心";
            lockVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lockVC animated:YES];
            break;
        }
        case 2: {
            RUNHistoryViewController *historyVC = [[RUNHistoryViewController alloc] init];
            historyVC.title = @"历史记录";
            historyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:historyVC animated:YES];
            break;
        }
        case 3: {
            RUNSettingViewController *setVC = [[RUNSettingViewController alloc] init];
            setVC.title = @"设置";
            setVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVC animated:YES];
            break;
        }

        default:
            break;
    }
}

- (void)p_refreshImage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults objectForKey:@"userIcon"];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image == nil) {
        image = [UIImage imageNamed:@"Oval 3"];
    }
    [self.headView setUserImage:image];
    
    // 刷新数据
    [self.userModel loadData];
    [self.headView setUserName:self.userModel.name];
    [self.headView setUserHeight:[self.userModel.height doubleValue]];
    [self.headView setUserWeight:[self.userModel.weight doubleValue]];
    [self.headView setUserTarget:[self.userModel.tag integerValue]];
}

- (void)p_reloadUserMessage {
    // 刷新数据
    [self.userModel loadData];
    [self.headView setUserName:self.userModel.name];
    [self.headView setUserHeight:[self.userModel.height doubleValue]];
    [self.headView setUserWeight:[self.userModel.weight doubleValue]];
    [self.headView setUserTarget:[self.userModel.tag integerValue]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RUNHEADIMAGENOTIFICATION object:nil];
}

@end
