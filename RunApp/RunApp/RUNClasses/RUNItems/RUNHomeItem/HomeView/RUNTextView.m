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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setLabels];
    }
    return self;
}

- (void)p_setLabels {
    self.valueLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.textColor = self.mainTitleColor;
    self.valueLabel.font = self.mainTitleFont;
    self.valueLabel.text = self.mainTitle;
    [self addSubview:self.valueLabel];
    
    self.unitLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.unitLabel.text = self.title;
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.textColor = self.titleColor;
    self.unitLabel.font = self.titleFont;
    [self addSubview:self.unitLabel];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.bottom).offset(-21);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueLabel.bottom).offset(2);
        make.left.right.equalTo(self.valueLabel);
        make.height.equalTo(21);
    }];
}

- (void)setLabelAnimation {

    self.valueLabel.method = UILabelCountingMethodLinear;
    self.valueLabel.format = self.format;
    [self.valueLabel countFrom:0 to:[self.mainTitle doubleValue] withDuration:self.animationDuration];
}

- (void)setMainTitle:(NSString *)mainTitle {
    _mainTitle = mainTitle;
    self.valueLabel.text = mainTitle;
}

- (void)setMainTitleFont:(UIFont *)mainTitleFont {
    self.valueLabel.font = mainTitleFont;
}

- (void)setMainTitleColor:(UIColor *)mainTitleColor {
    self.valueLabel.textColor = mainTitleColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.unitLabel.text = title;
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.unitLabel.font = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.unitLabel.textColor = titleColor;
}

@end
