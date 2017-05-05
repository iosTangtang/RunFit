//
//  RUNRAndFViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/22.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNRAndFViewController.h"
#import "RUNCheckCodeViewController.h"
#import "UITextField+Check.h"
#import "SVProgressHUD.h"
#import <BmobSDK/BmobSDK.h>

@interface RUNRAndFViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField   *phoneNumber;
@property (nonatomic, strong) UIButton      *nextButton;
@property (nonatomic, strong) UIButton      *toVerityButton;
@property (nonatomic, strong) UILabel       *fieldLabel;

@end

@implementation RUNRAndFViewController

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
    self.fieldLabel = [[UILabel alloc] init];
    self.fieldLabel.backgroundColor = [UIColor whiteColor];
    self.fieldLabel.text = @"中国 +86";
    self.fieldLabel.textAlignment = NSTextAlignmentCenter;
    self.fieldLabel.font = [UIFont systemFontOfSize:15.f];
    self.fieldLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.fieldLabel];
    
    self.phoneNumber = [[UITextField alloc] init];
    self.phoneNumber.backgroundColor = [UIColor whiteColor];
    self.phoneNumber.placeholder = @"输入手机号";
    self.phoneNumber.clearButtonMode = YES;
    self.phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    self.phoneNumber.delegate = self;
    self.phoneNumber.textColor = [UIColor grayColor];
    self.phoneNumber.textAlignment = NSTextAlignmentLeft;
    self.phoneNumber.returnKeyType = UIReturnKeyDone;
    self.phoneNumber.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.phoneNumber];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nextButton.backgroundColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTintColor:[UIColor whiteColor]];
    self.nextButton.layer.cornerRadius = 5;
    [self.nextButton addTarget:self action:@selector(p_nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    self.toVerityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.toVerityButton.backgroundColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
    [self.toVerityButton setTitle:@"已发送,直接验证" forState:UIControlStateNormal];
    [self.toVerityButton setTintColor:[UIColor whiteColor]];
    self.toVerityButton.layer.cornerRadius = 5;
    [self.toVerityButton addTarget:self action:@selector(p_toVerityAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toVerityButton];
    
    self.nextButton.enabled = NO;
    [self.phoneNumber becomeFirstResponder];
}

- (void)p_addConstrains {
    [self.fieldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.view.top).offset(20);
        make.height.equalTo(40);
        make.width.equalTo(ViewWidth / 5.0);
    }];
    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fieldLabel.top);
        make.left.equalTo(self.fieldLabel.right);
        make.right.equalTo(self.view.right);
        make.height.equalTo(40);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(35);
        make.right.equalTo(self.view.right).offset(-35);
        make.top.equalTo(self.phoneNumber.bottom).offset(25);
        make.height.equalTo(40);
    }];
    
    [self.toVerityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nextButton.left);
        make.right.equalTo(self.nextButton.right);
        make.top.equalTo(self.nextButton.bottom).offset(15);
        make.height.equalTo(self.nextButton.height);
    }];
}

#pragma mark - Next Action
- (void)p_nextAction:(UIButton *)button {
    if (![self.phoneNumber valiMobile]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式有误!"];
        return ;
    }
    
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumber.text andTemplate:@"RunFit" resultBlock:^(int number, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"请求验证码出错,请稍后再试"];
        } else {
            RUNCheckCodeViewController *checkCodeVC = [[RUNCheckCodeViewController alloc] init];
            checkCodeVC.title = @"填写验证码";
            checkCodeVC.phoneStr = self.phoneNumber.text;
            checkCodeVC.isChangePass = self.isChangePass;
            [self.navigationController pushViewController:checkCodeVC animated:YES];
        }
    }];
}

- (void)p_toVerityAction:(UIButton *)button {
    RUNCheckCodeViewController *checkCodeVC = [[RUNCheckCodeViewController alloc] init];
    checkCodeVC.title = @"填写验证码";
    checkCodeVC.phoneStr = self.phoneNumber.text;
    checkCodeVC.isChangePass = self.isChangePass;
    [self.navigationController pushViewController:checkCodeVC animated:YES];
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
