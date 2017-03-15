//
//  RUNFeedBackViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNFeedBackViewController.h"
#import "SVProgressHUD.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface RUNFeedBackViewController ()<UITextViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITextView    *textView;
@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, strong) UIButton      *sendButton;
@property (nonatomic, assign) CGFloat       keyBorderNumber;

@end

@implementation RUNFeedBackViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self p_createTextView];
    [self p_createTextField];
    [self p_createOtherThing];
    
}

- (void)p_createTextView {
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollEnabled = YES;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //允许编辑内容
    self.textView.editable = YES;
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.font = [UIFont systemFontOfSize:14.0];
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.layer.cornerRadius = 5.f;
    self.textView.text = @"在这里输入反馈...";
    //自适应高度
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(22);
        make.right.equalTo(self.view.mas_right).offset(-22);
        make.top.equalTo(self.view.mas_top).offset(15);
        make.height.equalTo(self.view.frame.size.height / 10.0 * 3);
    }];
}

- (void)p_createTextField {
    self.textField=[[UITextField alloc] init];
    self.textField.delegate = self;
    self.textField.placeholder = @"留下联系方式,方便答疑解惑(选填)";
    self.textField.font=[UIFont systemFontOfSize:14.0];
    self.textField.layer.borderWidth = 1;
    self.textField.textColor = [UIColor lightGrayColor];
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.textField.layer setCornerRadius:5];
    [self.view addSubview:self.textField];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(22);
        make.right.equalTo(self.view.mas_right).offset(-22);
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.height.equalTo(40);
    }];
}

- (void)p_createOtherThing {
    //初始化提交按钮
    self.sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.sendButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.sendButton setTintColor:[UIColor whiteColor]];
    self.sendButton.backgroundColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
    [self.sendButton addTarget:self action:@selector(sendMailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.layer.cornerRadius = 5.f;
    [self.view addSubview:self.sendButton];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textField);
        make.top.equalTo(self.textField.mas_bottom).offset(20);
        make.height.equalTo(40);
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.textView.text isEqualToString:@"在这里输入反馈..."]) {
        self.textView.text = @"";
    }
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = currentFrame.origin.y - 10;
    self.view.frame = currentFrame;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textView.text.length<1) {
        self.textView.text = @"在这里输入反馈...";
    }
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = 64;
    self.view.frame = currentFrame;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        CGRect currentFrame = self.view.frame;
        currentFrame.origin.y = 64;
        self.view.frame = currentFrame;
        return NO;
    }
    
    return YES;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = currentFrame.origin.y - self.keyBorderNumber / 2.0;
    self.view.frame = currentFrame;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = 64;
    self.view.frame = currentFrame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = 64;
    self.view.frame = currentFrame;
    
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark 计算键盘的高度
- (CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo {
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

- (void)keyboardWillAppear:(NSNotification *)notification {
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    self.keyBorderNumber = change;
}

#pragma mark 点击背景去键盘的方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
}

#pragma mark 点击提交按钮事件
- (void)sendMailButtonAction:(UIButton *)sender {
    if ([MFMailComposeViewController canSendMail] && ![self.textView.text isEqualToString:@"在这里输入反馈..."]) {
        [self sendMail];
    } else if ([self.textView.text isEqualToString:@"在这里输入反馈..."]) {
        [self p_showMessage:@"反馈为空" isSuccees:NO];
    } else {
        [self p_showMessage:@"未检测到邮件" isSuccees:NO];
    }
}

#pragma mark 发送邮件方法
- (void)sendMail {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    //设置邮件主题
    [mc setSubject:@"一封来自用户反馈的邮件"];
    
    //设置主收件人
    [mc setToRecipients:[NSArray arrayWithObjects:@"tangnian@xiyou3g.com", nil]];
    
    //设置邮件主体
    if (![self.textField.text isEqualToString:@""]) {
        NSString *str1 = self.textView.text;
        NSString *str2 = self.textField.text;
        NSString *sendStr = [NSString stringWithFormat:@"%@ 反馈者的联系方式: %@", str1, str2];
        [mc setMessageBody:sendStr isHTML:NO];
    } else {
        [mc setMessageBody:self.textView.text isHTML:NO];
    }
    
    [self presentViewController:mc animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            [self p_showMessage:@"反馈成功" isSuccees:YES];
            break;
        case MFMailComposeResultFailed:
            [self p_showMessage:@"反馈失败" isSuccees:NO];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 提示框
- (void)p_showMessage:(NSString *)title isSuccees:(BOOL)isSucceed {
    if (isSucceed) {
        [SVProgressHUD showSuccessWithStatus:title];
    } else {
        [SVProgressHUD showErrorWithStatus:title];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
