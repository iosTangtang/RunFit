//
//  RUNPickViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNPickViewController.h"

@interface RUNPickViewController () <UIPickerViewDataSource,UIPickerViewDelegate> {
    NSString *_separator;
}

@property (nonatomic, strong)   NSMutableString      *chooseText;
@property (nonatomic, strong)   UILabel              *titleLabel;
@property (nonatomic, strong)   UIView               *backView;
@property (nonatomic, strong)   UIPickerView         *pickerView;

@end

@implementation RUNPickViewController

- (NSMutableString *)chooseText {
    if (!_chooseText) {
        _chooseText = [NSMutableString string];
    }
    return _chooseText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupView
- (void)p_setupView {
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = self.backGroundColor;
    [self.view addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).offset(0);
        make.height.equalTo(@250);
    }];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.backView addSubview:self.pickerView];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.backView).offset(0);
    }];
    
    for (int index = 0; index < self.defaultData.count; index++) {
        [self.pickerView selectRow:[self.defaultData[index] integerValue] - [self.dValue[index] integerValue]
                       inComponent:index animated:NO];
    }
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.mainTitle;
    self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14.f];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView.mas_centerX);
        make.height.equalTo(@25);
        make.top.equalTo(self.backView.mas_top).offset(4.5);
    }];
    
    UIButton *overButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [overButton setTitle:@"完成" forState:UIControlStateNormal];
    [overButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    overButton.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:13.f];
    [overButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:overButton];
    
    [overButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-8);
        make.top.equalTo(self.backView.mas_top).offset(4.5);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
}

- (void)buttonAction:(UIButton *)sender {
    self.chooseText = [NSMutableString stringWithString:@""];
    for (int index = 0; index < self.datas.count; index++) {
        NSInteger row = [self.pickerView selectedRowInComponent:index];
        NSArray *array = self.datas[index];
        if (index == self.datas.count - 1) {
            if (self.datas.count > 1 && !self.isDate) {
                self.chooseText = [NSMutableString stringWithString:[self.chooseText substringToIndex:self.chooseText.length - 1]];
            }
            if (self.isTime) {
                [self.chooseText appendFormat:@":"];
            }
            [self.chooseText appendFormat:@"%@", array[row]];
            continue;
        }
        [self.chooseText appendFormat:@"%@%@", array[row], self.separator];
    }
    
    if (self.pickDelegate && [self.pickDelegate respondsToSelector:@selector(pickText:)]) {
        [self.pickDelegate pickText:self.chooseText];
    }
    if (self.pickDelegate && [self.pickDelegate respondsToSelector:@selector(pickText:withRow:)]) {
        [self.pickDelegate pickText:self.chooseText withRow:self.row];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (self.defaultData && self.dValue && self.isDate) {
        NSInteger index = [self.defaultData[component] integerValue] - [self.dValue[component] integerValue];
        if (row > index) {
            [pickerView selectRow:[self.defaultData[component] integerValue] - [self.dValue[component] integerValue]
                      inComponent:component animated:YES];
        }
    }
}

#pragma mark - 点击背景去掉pickerView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
