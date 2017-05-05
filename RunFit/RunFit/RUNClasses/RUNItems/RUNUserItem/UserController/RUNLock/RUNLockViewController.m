//
//  RUNLockViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNLockViewController.h"
#import "RUNCloudDataBase.h"
#import "SVProgressHUD.h"

@interface RUNLockViewController ()

@property (nonatomic, strong)   UILabel *messageLabel;

@end

@implementation RUNLockViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI Method
- (void)p_setUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"数据同步说明";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(60);
        make.left.equalTo(self.view.left).offset(21);
        make.width.equalTo(96);
        make.height.equalTo(22);
    }];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = @"同步数据至云端: 将本地数据同步到云端。\n同步数据至本地: 将云端数据同步到本地。";
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont systemFontOfSize:14.f];
    self.messageLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
    [self.view addSubview:self.messageLabel];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(21);
        make.right.equalTo(self.view.right).offset(-21);
        make.top.equalTo(titleLabel.bottom).offset(5);
        make.height.equalTo(70);
        make.width.equalTo(ViewWidth - 42);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"同步数据至云端" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    button.backgroundColor = [UIColor colorWithRed:86 / 255.0 green:209 / 255.0 blue:240 / 255.0 alpha:1];
    [button addTarget:self action:@selector(p_upButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.bottom).offset(60);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(ViewWidth / 2.0);
        make.height.equalTo(ViewHeight / 15.0);
    }];
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [downButton setTitle:@"同步数据至本地" forState:UIControlStateNormal];
    [downButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    downButton.backgroundColor = [UIColor colorWithRed:86 / 255.0 green:209 / 255.0 blue:240 / 255.0 alpha:1];
    [downButton addTarget:self action:@selector(p_downButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
    
    [downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.bottom).offset(30);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(ViewWidth / 2.0);
        make.height.equalTo(ViewHeight / 15.0);
    }];
}

#pragma mark - Button Action
- (void)p_upButtonAction:(UIButton *)button {
    RUNCloudDataBase *cloudDB = [[RUNCloudDataBase alloc] init];
    [cloudDB updateToCloudWithBlock:^(BOOL isSuccessful, int status, NSError *error) {
        if (isSuccessful && status == 0) {
            [SVProgressHUD showSuccessWithStatus:@"同步成功!"];
        } else if (isSuccessful && status == 1) {
            [SVProgressHUD showInfoWithStatus:@"数据已是最新，无需再次同步。"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"同步失败，请检查网络设置。"];
        }
    }];
}

- (void)p_downButtonAction:(UIButton *)button {
    RUNCloudDataBase *cloudDB = [[RUNCloudDataBase alloc] init];
    [cloudDB downToLocateWithBlock:^(BOOL isSuccessful, int status, NSError *error) {
        if (isSuccessful) {
            [SVProgressHUD showSuccessWithStatus:@"同步成功!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:RUNHEADIMAGENOTIFICATION object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RUNREFRESHNOTIFICATION object:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"同步失败，请检查网络设置。"];
        }
    }];
}

@end
