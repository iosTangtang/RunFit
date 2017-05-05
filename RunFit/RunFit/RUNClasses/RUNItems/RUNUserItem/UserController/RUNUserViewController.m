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
#import "RUNNavigationViewController.h"
#import "RUNHeadAndUserNameViewController.h"
#import "RUNUpdatePassViewController.h"
#import "RUNLoginViewController.h"
#import "RUNUserHeadView.h"
#import "RUNButton.h"
#import "RUNUserModel.h"
#import "UIImageView+WebCache.h"
#import <BmobSDK/BmobSDK.h>

@interface RUNUserViewController () <RUNUserHeadDelegate>

@property (nonatomic, strong) RUNUserHeadView   *userHead;
@property (nonatomic, copy)   NSArray           *images;
@property (nonatomic, copy)   NSArray           *titles;
@property (nonatomic, strong) RUNUserHeadView   *headView;
@property (nonatomic, strong) RUNUserModel      *userModel;

@end

@implementation RUNUserViewController

- (NSArray *)images {
    if (!_images) {
        _images = @[@"userEdit", @"changePass", @"upData", @"history", @"set"];
    }
    return _images;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"个人资料", @"密码修改", @"数据同步", @"历史记录", @"设置"];
    }
    return _titles;
}

- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
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
    
    [self.userModel loadData];
    [self p_setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI Method
- (void)p_setUI {
    BmobUser *user = [BmobUser currentUser];
    BmobFile *file = (BmobFile *)[user objectForKey:@"headImage"];
    NSString *url = file.url;
    
    self.headView = [[RUNUserHeadView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight / 2.0)];
    self.headView.delegate = self;
    if (![self.userModel.isLogin boolValue]) {
        [self.headView setUserName:@"Run用户"];
        [self.headView setUserImageWithUrl:nil placeholderImage:[UIImage imageNamed:@"unLogin"]];
    } else {
        [self.headView setUserName:self.userModel.name];
        [self.headView setUserImageWithUrl:url placeholderImage:[UIImage imageNamed:@"Oval 3"]];
    }
    
    [self.headView setUserHeight:[self.userModel.height doubleValue]];
    [self.headView setUserWeight:[self.userModel.weight doubleValue]];
    [self.headView setUserBMI:[[NSString stringWithFormat:@"%.1f", [self.userModel.weight doubleValue] /
                                pow([self.userModel.height doubleValue] / 100, 2)] doubleValue]];
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
            if ([self.userModel.isLogin boolValue] == NO) {
                RUNLoginViewController *login = [[RUNLoginViewController alloc] init];
                RUNNavigationViewController *nav = [[RUNNavigationViewController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
                return ;
            }
            RUNUpdatePassViewController *changePass = [[RUNUpdatePassViewController alloc] init];
            changePass.title = @"修改密码";
            changePass.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:changePass animated:YES];
            break;
        }
        case 2: {
            if ([self.userModel.isLogin boolValue] == NO) {
                RUNLoginViewController *login = [[RUNLoginViewController alloc] init];
                RUNNavigationViewController *nav = [[RUNNavigationViewController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
                return ;
            }
            RUNLockViewController *lockVC = [[RUNLockViewController alloc] init];
            lockVC.title = @"数据同步";
            lockVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lockVC animated:YES];
            break;
        }
        case 3: {
            RUNHistoryViewController *historyVC = [[RUNHistoryViewController alloc] init];
            historyVC.title = @"历史记录";
            historyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:historyVC animated:YES];
            break;
        }
        case 4: {
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

#pragma mark - RUNUser Delegate 
- (void)userHeadClick {
    if ([self.userModel.isLogin boolValue]) {
        RUNHeadAndUserNameViewController *headVC = [[RUNHeadAndUserNameViewController alloc] init];
        headVC.hidesBottomBarWhenPushed = YES;
        headVC.title = @"个性设置";
        [self.navigationController pushViewController:headVC animated:YES];
        return;
    }
    RUNLoginViewController *login = [[RUNLoginViewController alloc] init];
    RUNNavigationViewController *nav = [[RUNNavigationViewController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)p_refreshImage {
    // 刷新数据
    [self.userModel loadData];
    BmobUser *user = [BmobUser currentUser];
    BmobFile *file = (BmobFile *)[user objectForKey:@"headImage"];
    NSString *url = file.url;
    
    if (![self.userModel.isLogin boolValue]) {
        [self.headView setUserName:@"Run用户"];
        [self.headView setUserImageWithUrl:nil placeholderImage:[UIImage imageNamed:@"unLogin"]];
    } else {
        [self.headView setUserName:self.userModel.name];
        [self.headView setUserImageWithUrl:url placeholderImage:[UIImage imageNamed:@"Oval 3"]];
    }
    [self.headView setUserHeight:[self.userModel.height doubleValue]];
    [self.headView setUserWeight:[self.userModel.weight doubleValue]];
    [self.headView setUserBMI:[[NSString stringWithFormat:@"%.1f", [self.userModel.weight doubleValue] /
                                pow([self.userModel.height doubleValue] / 100, 2)] doubleValue]];
    [self.headView setUserTarget:[self.userModel.tag integerValue]];
}

- (void)p_reloadUserMessage {
    // 刷新数据
    [self.userModel loadData];
    [self.headView setUserName:self.userModel.name];
    [self.headView setUserHeight:[self.userModel.height doubleValue]];
    [self.headView setUserWeight:[self.userModel.weight doubleValue]];
    [self.headView setUserBMI:[[NSString stringWithFormat:@"%.1f", [self.userModel.weight doubleValue] /
                                pow([self.userModel.height doubleValue] / 100, 2)] doubleValue]];
    [self.headView setUserTarget:[self.userModel.tag integerValue]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RUNHEADIMAGENOTIFICATION object:nil];
}

@end
