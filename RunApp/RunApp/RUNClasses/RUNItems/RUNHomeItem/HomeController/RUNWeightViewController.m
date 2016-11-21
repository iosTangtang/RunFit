//
//  RUNWeightViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNWeightViewController.h"
#import "SVProgressHUD.h"
#import "RUNUserModel.h"

@interface RUNWeightViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) RUNUserModel      *userModel;
@property (nonatomic, strong) UIPickerView      *pickerView;
@property (nonatomic, copy)   NSArray           *datas;
@property (nonatomic, strong) NSMutableString   *chooseText;

@end

@implementation RUNWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setNavigationItem];
    [self p_setPickView];
}

#pragma mark - Navigation Item
- (void)p_setNavigationItem {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(p_overAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - Over Action
- (void)p_overAction:(UIBarButtonItem *)barButton {
    [SVProgressHUD showWithStatus:@"保存中..."];
    __weak typeof(self) weakSelf = self;
    self.userModel.weight = self.chooseText;
    [self.userModel saveData:^{
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:RUNUSERNOTIFICATION object:nil];
    }];
}

#pragma mark - Set PickView
- (void)p_setPickView {
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:self.pickerView];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(30);
        make.height.equalTo(250);
    }];
}

#pragma mark - UIPickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.datas.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *array = self.datas[component];
    return array.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    NSArray *data = self.datas[component];
    return data[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.frame.size.width / self.datas.count;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    int index;
    self.chooseText = [NSMutableString stringWithString:@""];
    
    for (index = 0; index < self.datas.count - 1; index++) {
        NSInteger selectedRow = [pickerView selectedRowInComponent:index];
        [self.chooseText appendFormat:@"%@.", [self.datas[index] objectAtIndex:selectedRow]];
    }
    
    NSInteger selectedRow = [pickerView selectedRowInComponent:index];
    if (self.datas.count > 1) {
        self.chooseText = [NSMutableString stringWithString:[self.chooseText substringToIndex:self.chooseText.length - 1]];
    }
    [self.chooseText appendFormat:@"%@", [self.datas[index] objectAtIndex:selectedRow]];
    
}

#pragma mark - Set Method
- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}

- (NSArray *)datas {
    if (!_datas) {
        NSMutableArray *weight1 = [NSMutableArray array];
        NSMutableArray *weight2 = [NSMutableArray array];
        for (int index = 25; index < 251; index++) {
            [weight1 addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 0; index < 10; index++) {
            [weight2 addObject:[NSString stringWithFormat:@"%d", index]];
        }
        _datas = @[weight1, weight2, @[@"kg"]];
    }
    return _datas;
}

- (NSMutableString *)chooseText {
    if (!_chooseText) {
        _chooseText = [NSMutableString stringWithString:@""];
    }
    return _chooseText;
}

@end
