//
//  RUNUpdatePassViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/12/17.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNUpdatePassViewController.h"
#import "UITextField+Check.h"
#import "SVProgressHUD.h"
#import "RUNUserModel.h"
#import <BmobSDK/BmobSDK.h>

@interface RUNUpdatePassViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField   *oldPass;
@property (nonatomic, strong) UITextField   *passWord;
@property (nonatomic, strong) UITextField   *passAgain;
@property (nonatomic, strong) UIButton      *changeButton;

@end

@implementation RUNUpdatePassViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self p_setUIMethod];
    [self p_addConstrains];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI Method
- (void)p_setUIMethod {
    self.oldPass = [self p_setTextField:@"输入旧密码"];
    [self.view addSubview:self.oldPass];
    
    self.passWord = [self p_setTextField:@"输入新密码"];
    [self.view addSubview:self.passWord];
    
    self.passAgain = [self p_setTextField:@"再次输入新密码"];
    [self.view addSubview:self.passAgain];
    
    self.changeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.changeButton.backgroundColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
    [self.changeButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.changeButton setTintColor:[UIColor whiteColor]];
    self.changeButton.layer.cornerRadius = 5;
    [self.changeButton addTarget:self action:@selector(p_changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeButton];
    
    self.changeButton.enabled = NO;
}

- (void)p_addConstrains {
    [self.oldPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    [self.passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldPass.bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    [self.passAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passWord.bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(35);
        make.right.equalTo(self.view.right).offset(-35);
        make.top.equalTo(self.passAgain.bottom).offset(25);
        make.height.equalTo(40);
    }];
}

#pragma mark - Change Pass Action
- (void)p_changeAction:(UIButton *)button {
    if (![self.oldPass valiPassword] || ![self.passWord valiPassword] || ![self.passAgain valiPassword]) {
        [SVProgressHUD showErrorWithStatus:@"密码格式有误"];
        return ;
    }
    if (![self.passWord.text isEqualToString:self.passAgain.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次新密码输入不一致"];
        return ;
    }
    
    BmobUser *user = [BmobUser currentUser];
    [SVProgressHUD showWithStatus:@"修改中"];
    [user updateCurrentUserPasswordWithOldPassword:self.oldPass.text newPassword:self.passWord.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [BmobUser loginInbackgroundWithAccount:user.username andPassword:self.passWord.text block:^(BmobUser *user, NSError *error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"自动登录失败,请检查网络再次登录"];
                    [self p_changStatus];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"修改密码失败"];
        }
    }];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.oldPass resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.passAgain resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![self.oldPass.text isEqualToString:@""] && ![self.passWord.text isEqualToString:@""] && ![self.passAgain.text isEqualToString:@""]) {
        self.changeButton.enabled = YES;
    } else {
        self.changeButton.enabled = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![self.oldPass.text isEqualToString:@""] && ![self.passWord.text isEqualToString:@""] && ![self.passAgain.text isEqualToString:@""]) {
        self.changeButton.enabled = YES;
    } else {
        self.changeButton.enabled = NO;
    }
    
    return YES;
}

#pragma mark - 点击背景去键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.oldPass resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.passAgain resignFirstResponder];
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

- (UITextField *)p_setTextField:(NSString *)title {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = title;
    textField.secureTextEntry = YES;
    textField.clearButtonMode = YES;
    textField.delegate = self;
    textField.textColor = [UIColor grayColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.returnKeyType = UIReturnKeyDone;
    textField.font = [UIFont systemFontOfSize:15.f];
    return textField;
}


@end
