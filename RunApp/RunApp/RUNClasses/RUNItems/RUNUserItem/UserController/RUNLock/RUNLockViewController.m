//
//  RUNLockViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNLockViewController.h"

@interface RUNLockViewController ()

@property (nonatomic, strong)   UILabel *messageLabel;
@property (nonatomic, copy)     NSArray *messages;
@property (nonatomic, assign)   BOOL    isOpen;

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
    self.isOpen = NO;
    
    [self p_setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI Method
- (void)p_setUI {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"health"]];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.view.top).offset(60);
        make.width.height.equalTo(60);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"数据同步说明";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.bottom).offset(60);
        make.left.equalTo(self.view.left).offset(21);
        make.width.equalTo(96);
        make.height.equalTo(22);
    }];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = self.messages[0];
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
    [button setTitle:@"开启健康数据同步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    button.backgroundColor = [UIColor colorWithRed:86 / 255.0 green:209 / 255.0 blue:240 / 255.0 alpha:1];
    [button addTarget:self action:@selector(p_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.bottom).offset(50);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(ViewWidth / 2.0);
        make.height.equalTo(ViewHeight / 15.0);
    }];
}

#pragma mark - Button Action
- (void)p_buttonAction:(UIButton *)button {
    if (!self.isOpen) {
        [button setTitle:@"关闭健康数据同步" forState:UIControlStateNormal];
        self.messageLabel.text = self.messages[1];
        self.isOpen = YES;
    } else {
        [button setTitle:@"开启健康数据同步" forState:UIControlStateNormal];
        self.messageLabel.text = self.messages[0];
        self.isOpen = NO;
    }
}

@end
