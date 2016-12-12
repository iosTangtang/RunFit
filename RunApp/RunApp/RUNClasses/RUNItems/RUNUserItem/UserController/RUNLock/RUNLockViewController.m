//
//  RUNLockViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNLockViewController.h"
#import "SVProgressHUD.h"

@interface RUNLockViewController ()

@property (nonatomic, strong)   UILabel *messageLabel;
@property (nonatomic, copy)     NSArray *messages;

@end

@implementation RUNLockViewController

- (NSArray *)messages {
    if (!_messages) {
        _messages = @[@"        现在您的数据是应用为您统计的，开启同步后将同步健康中的数据到应用中，该应用记录的数据也将写入健康中。",
                      @"        现在您的数据是读取健康应用的数据，该应用将同步健康中的数据，关闭后无法同步，请谨慎选择。"];
    }
    return _messages;
}

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
static float progress = 0.0f;
- (void)p_upButtonAction:(UIButton *)button {
    progress = 0.0f;
    [SVProgressHUD showProgress:0 status:@"同步中"];
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.1f];
}

- (void)p_downButtonAction:(UIButton *)button {
    progress = 0.0f;
    [SVProgressHUD showProgress:0 status:@"同步中"];
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.1f];
}

- (void)increaseProgress {
    progress += 0.05f;
    [SVProgressHUD showProgress:progress status:@"同步中"];
    
    if(progress < 1.0f){
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.1f];
    } else {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.4f];
    }
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}


@end
