//
//  RUNTextView.m
//  RunApp
//
//  Created by Tangtang on 2016/11/7.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNTextView.h"
#import "UICountingLabel.h"

@interface RUNTextView ()

@property (nonatomic, strong) UICountingLabel   *valueLabel;
@property (nonatomic, strong) UICountingLabel   *unitLabel;

@end

@implementation RUNTextView

- (void)setLabels {
    self.valueLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.textColor = self.titleColor;
    self.valueLabel.font = [UIFont fontWithName:@"Helvetica" size:ViewHeight / 20.f];
    self.valueLabel.method = UILabelCountingMethodLinear;
    self.valueLabel.format = self.format;
    [self addSubview:self.valueLabel];
    
    self.unitLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.unitLabel.text = self.title;
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.textColor = [UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:1];
    self.unitLabel.font = [UIFont systemFontOfSize:12.f];
    [self addSubview:self.unitLabel];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.bottom).offset(-21);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueLabel.bottom).offset(-3);
        make.left.right.equalTo(self.valueLabel);
        make.height.equalTo(21);
    }];
    
    [self.valueLabel countFrom:0 to:[self.mainTitle doubleValue] withDuration:self.animationDuration];
    
}

@end
