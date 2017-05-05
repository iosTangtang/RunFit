//
//  RUNCheckCodeViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/22.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNCheckCodeViewController.h"
#import "RUNChangePassViewController.h"
#import "UITextField+Check.h"
#import "SVProgressHUD.h"
#import <BmobSDK/BmobSDK.h>

@interface RUNCheckCodeViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField   *phoneNumber;
@property (nonatomic, strong) UIButton      *nextButton;
@property (nonatomic, strong) UIButton      *refreshButton;
@property (nonatomic, assign) NSInteger         iCount;
@property (nonatomic, strong) NSTimer           *timer;

@end

@implementation RUNCheckCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self p_setUIMethod];
    [self p_addConstrains];
    
    self.iCount = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(p_scrollTimer)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI Method
- (void)p_setUIMethod {
    self.phoneNumber = [[UITextField alloc] init];
    self.phoneNumber.backgroundColor = [UIColor whiteColor];
    self.phoneNumber.placeholder = @"输入验证码";
    self.phoneNumber.clearButtonMode = YES;
    self.phoneNumber.delegate = self;
    self.phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    self.phoneNumber.textColor = [UIColor grayColor];
    self.phoneNumber.textAlignment = NSTextAlignmentCenter;
    self.phoneNumber.returnKeyType = UIReturnKeyDone;
    self.phoneNumber.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.phoneNumber];
    
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.refreshButton.backgroundColor = [UIColor whiteColor];
    [self.refreshButton setTitle:@"重新发送(59s)" forState:UIControlStateDisabled];
    [self.refreshButton setTintColor:[UIColor grayColor]];
    [self.refreshButton addTarget:self action:@selector(p_refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshButton];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nextButton.backgroundColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTintColor:[UIColor whiteColor]];
    self.nextButton.layer.cornerRadius = 5;
    [self.nextButton addTarget:self action:@selector(p_nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    self.nextButton.enabled = NO;
    self.refreshButton.enabled = NO;
    [self.phoneNumber becomeFirstResponder];
}

- (void)p_addConstrains {
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(20);
        make.left.equalTo(self.view.left);
        make.width.equalTo(ViewWidth / 5.0 * 3);
        make.height.equalTo(40);
    }];
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumber.top);
        make.left.equalTo(self.phoneNumber.right);
        make.right.equalTo(self.view.right);
        make.height.equalTo(40);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(35);
        make.right.equalTo(self.view.right).offset(-35);
        make.top.equalTo(self.phoneNumber.bottom).offset(25);
        make.height.equalTo(40);
    }];
}

#pragma mark - Next Action
- (void)p_nextAction:(UIButton *)button {
    if (![self.phoneNumber valiSMSCode]) {
        [SVProgressHUD showErrorWithStatus:@"验证码格式有误!"];
        return;
    }
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.phoneStr andSMSCode:self.phoneNumber.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            RUNChangePassViewController *changeVC = [[RUNChangePassViewController alloc] init];
            changeVC.title = @"密码";
            changeVC.smsCode = self.phoneNumber.text;
            changeVC.phoneStr = self.phoneStr;
            changeVC.isChangePass = self.isChangePass;
            [self.navigationController pushViewController:changeVC animated:YES];
        } else {
            if (error.code == 207) {
                [SVProgressHUD showErrorWithStatus:@"验证码已失效"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"验证出错,请检查网络设置"];
            }
        }
    }];
}

- (void)p_refreshAction:(UIButton *)button {
    self.refreshButton.enabled = NO;
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneStr andTemplate:@"RunFit" resultBlock:^(int number, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"请求验证码出错,请检查网络设置"];
            self.refreshButton.enabled = YES;
        } else {
            [self.refreshButton setTitle:@"重新发送" forState:UIControlStateDisabled];
            self.iCount = 0;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(p_scrollTimer)
                                                        userInfo:nil
                                                         repeats:YES];
        }
    }];
}

- (void)p_scrollTimer {
    if (self.iCount == 59) {
        self.refreshButton.titleLabel.text = @"重新发送";
        [self.refreshButton setTitle:@"重新发送" forState:UIControlStateNormal];
        self.refreshButton.enabled = YES;
        [self.timer invalidate];
        return;
    }
    self.iCount++;
    self.refreshButton.titleLabel.text = [NSString stringWithFormat:@"重新发送(%zds)", 60 - self.iCount] ;
    [self.refreshButton setTitle:[NSString stringWithFormat:@"重新发送(%zds)", 60 - self.iCount] forState:UIControlStateDisabled];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.phoneNumber resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![self.phoneNumber.text isEqualToString:@""]) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![self.phoneNumber.text isEqualToString:@""]) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
    
    return YES;
}

#pragma mark - 点击背景去键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.phoneNumber resignFirstResponder];
}

@end
