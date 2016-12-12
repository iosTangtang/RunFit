//
//  RUNLoginViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/22.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNLoginViewController.h"
#import "RUNRAndFViewController.h"
#import "RUNUserModel.h"
#import "UITextField+Check.h"
#import "SVProgressHUD.h"
#import "Bmob.h"

@interface RUNLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField   *userName;
@property (nonatomic, strong) UITextField   *password;
@property (nonatomic, strong) UIButton      *loginButton;

@end

@implementation RUNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"登陆";
    
    [self p_setNavigation];
    [self p_setUIMethod];
    [self p_addConstrains];
    [self p_addButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Item
- (void)p_setNavigation {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(p_leftBarItemAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

#pragma mark - Set UI Method
- (void)p_setUIMethod {
    self.userName = [[UITextField alloc] init];
    self.userName.backgroundColor = [UIColor whiteColor];
    self.userName.placeholder = @"输入手机号";
    self.userName.clearButtonMode = YES;
    self.userName.delegate = self;
    self.userName.keyboardType = UIKeyboardTypePhonePad;
    self.userName.textColor = [UIColor grayColor];
    self.userName.textAlignment = NSTextAlignmentCenter;
    self.userName.returnKeyType = UIReturnKeyDone;
    self.userName.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.userName];
    
    self.password = [[UITextField alloc] init];
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.placeholder = @"输入密码";
    self.password.secureTextEntry = YES;
    self.password.clearButtonMode = YES;
    self.password.delegate = self;
    self.password.textColor = [UIColor grayColor];
    self.password.textAlignment = NSTextAlignmentCenter;
    self.password.returnKeyType = UIReturnKeyDone;
    self.password.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.password];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.backgroundColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginButton setTintColor:[UIColor whiteColor]];
    self.loginButton.layer.cornerRadius = 5;
    [self.loginButton addTarget:self action:@selector(p_loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.loginButton.enabled = NO;
    [self.userName becomeFirstResponder];
}

- (void)p_addConstrains {
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(35);
        make.right.equalTo(self.view.right).offset(-35);
        make.top.equalTo(self.password.bottom).offset(25);
        make.height.equalTo(40);
    }];
}

#pragma mark - Add Button
- (void)p_addButton {
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [forgetButton addTarget:self action:@selector(p_forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registerButton setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [registerButton addTarget:self action:@selector(p_registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(10);
        make.bottom.equalTo(self.view.bottom).offset(-10);
        make.width.equalTo(80);
        make.height.equalTo(25);
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-10);
        make.bottom.equalTo(forgetButton.bottom);
        make.width.equalTo(80);
        make.height.equalTo(25);
    }];
}

#pragma mark - buttonAction
- (void)p_loginAction {
    if (![self.userName valiMobile]) {
        [SVProgressHUD showErrorWithStatus:@"手机格式有误!"];
        return ;
    }
    
    if (![self.password valiPassword]) {
        [SVProgressHUD showErrorWithStatus:@"密码格式有误!"];
        return ;
    }
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    RUNUserModel *model = [[RUNUserModel alloc] init];
    [model loadData];
    model.isLogin = @"YES";
    [model saveLoginStatus];
    [[NSNotificationCenter defaultCenter] postNotificationName:RUNHEADIMAGENOTIFICATION object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)p_forgetAction:(UIButton *)button {
    RUNRAndFViewController *forgetVC = [[RUNRAndFViewController alloc] init];
    forgetVC.title = @"找回密码";
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)p_registerAction:(UIButton *)button {
    RUNRAndFViewController *registerVC = [[RUNRAndFViewController alloc] init];
    registerVC.title = @"新用户注册";
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - Bar Item Action
- (void)p_leftBarItemAction:(UIBarButtonItem *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![self.userName.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![self.userName.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
    
    return YES;
}

#pragma mark - 点击背景去键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

@end
