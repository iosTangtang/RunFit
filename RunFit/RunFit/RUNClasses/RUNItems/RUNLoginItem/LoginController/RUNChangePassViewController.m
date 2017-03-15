//
//  RUNChangePassViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/22.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNChangePassViewController.h"
#import "UITextField+Check.h"
#import "SVProgressHUD.h"
#import <BmobSDK/BmobSDK.h>

@interface RUNChangePassViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField   *passWord;
@property (nonatomic, strong) UITextField   *passWordAgain;
@property (nonatomic, strong) UIButton      *overButton;

@end

@implementation RUNChangePassViewController

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
    self.passWord = [[UITextField alloc] init];
    self.passWord.backgroundColor = [UIColor whiteColor];
    self.passWord.placeholder = @"输入新密码(6-16位，不含空格)";
    self.passWord.clearButtonMode = YES;
    self.passWord.secureTextEntry = YES;
    self.passWord.delegate = self;
    self.passWord.textColor = [UIColor grayColor];
    self.passWord.textAlignment = NSTextAlignmentCenter;
    self.passWord.returnKeyType = UIReturnKeyDone;
    self.passWord.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.passWord];
    
    self.passWordAgain = [[UITextField alloc] init];
    self.passWordAgain.backgroundColor = [UIColor whiteColor];
    self.passWordAgain.placeholder = @"再次输入密码";
    self.passWordAgain.secureTextEntry = YES;
    self.passWordAgain.clearButtonMode = YES;
    self.passWordAgain.delegate = self;
    self.passWordAgain.textColor = [UIColor grayColor];
    self.passWordAgain.textAlignment = NSTextAlignmentCenter;
    self.passWordAgain.returnKeyType = UIReturnKeyDone;
    self.passWordAgain.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.passWordAgain];
    
    self.overButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.overButton.backgroundColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
    [self.overButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.overButton setTintColor:[UIColor whiteColor]];
    self.overButton.layer.cornerRadius = 5;
    [self.overButton addTarget:self action:@selector(p_overAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.overButton];
    
    self.overButton.enabled = NO;
    [self.passWord becomeFirstResponder];
}

- (void)p_addConstrains {
    [self.passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    [self.passWordAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passWord.bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    [self.overButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(35);
        make.right.equalTo(self.view.right).offset(-35);
        make.top.equalTo(self.passWordAgain.bottom).offset(25);
        make.height.equalTo(40);
    }];
}

#pragma mark - buttonAction
- (void)p_overAction {
    if (![self.passWord valiPassword] || ![self.passWordAgain valiPassword]) {
        [SVProgressHUD showErrorWithStatus:@"密码格式有误!"];
        return ;
    }
    if (![self.passWord.text isEqualToString:self.passWordAgain.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不相同!"];
        return ;
    }
    
    if (self.isChangePass) {
        [self p_resetPassWord];
    } else {
        [self p_signUp];
    }
}

- (void)p_resetPassWord {
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.smsCode andNewPassword:self.passWord.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功,请重新登录"];
            [self.passWord resignFirstResponder];
            [self.passWordAgain resignFirstResponder];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            if (error.code == 207) {
                [SVProgressHUD showErrorWithStatus:@"验证码出错"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"修改密码失败,请检查网络设置"];
            }
            
        }
    }];
}

- (void)p_signUp {
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.phoneStr];
    [bUser setMobilePhoneNumber:self.phoneStr];
    [bUser setPassword:self.passWord.text];
    [SVProgressHUD showWithStatus:@"注册中"];
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [self.passWord resignFirstResponder];
            [self.passWordAgain resignFirstResponder];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            if (error.code == 209) {
                [SVProgressHUD showErrorWithStatus:@"注册失败,手机号码已存在"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"注册失败,请检查网络设置"];
            }
            
        }
    }];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.passWord resignFirstResponder];
    [self.passWordAgain resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![self.passWord.text isEqualToString:@""] && ![self.passWordAgain.text isEqualToString:@""]) {
        self.overButton.enabled = YES;
    } else {
        self.overButton.enabled = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![self.passWord.text isEqualToString:@""] && ![self.passWordAgain.text isEqualToString:@""]) {
        self.overButton.enabled = YES;
    } else {
        self.overButton.enabled = NO;
    }
    
    return YES;
}

#pragma mark - 点击背景去键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.passWord resignFirstResponder];
    [self.passWordAgain resignFirstResponder];
}

@end
