//
//  RUNToolViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNToolViewController.h"

@interface RUNToolViewController ()

@end

@implementation RUNToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setToolUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set Tool UI
- (void)p_setToolUI {
    UIButton *rotate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rotate setImage:[UIImage imageNamed:@"transition90"] forState:UIControlStateNormal];
    [rotate setTintColor:[UIColor colorWithRed:182 / 255.0 green:179 / 255.0 blue:179 / 255.0 alpha:1]];
    rotate.layer.borderWidth = 1.f;
    rotate.layer.borderColor = [UIColor colorWithRed:182 / 255.0 green:179 / 255.0 blue:179 / 255.0 alpha:1].CGColor;
    rotate.layer.cornerRadius = 24.f;
    [rotate addTarget:self action:@selector(p_rotateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotate];
    
    [rotate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(ViewWidth / 4.0 - 24);
        make.centerY.equalTo(self.view.centerY);
        make.width.equalTo(48);
        make.height.equalTo(48);
    }];
    
    UIButton *cut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cut setImage:[UIImage imageNamed:@"cut"] forState:UIControlStateNormal];
    [cut setTintColor:[UIColor colorWithRed:182 / 255.0 green:179 / 255.0 blue:179 / 255.0 alpha:1]];
    cut.layer.borderWidth = 1.f;
    cut.layer.borderColor = [UIColor colorWithRed:182 / 255.0 green:179 / 255.0 blue:179 / 255.0 alpha:1].CGColor;
    cut.layer.cornerRadius = 24.f;
    [cut addTarget:self action:@selector(p_cutButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cut];
    
    [cut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-ViewWidth / 4.0 + 24);
        make.centerY.equalTo(self.view.centerY);
        make.width.equalTo(48);
        make.height.equalTo(48);
    }];
}

#pragma mark - Button Action
- (void)p_rotateButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(rotateAction:)]) {
        [self.delegate rotateAction:button];
    }
}

- (void)p_cutButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cutAction:)]) {
        [self.delegate cutAction:button];
    }
}

@end
