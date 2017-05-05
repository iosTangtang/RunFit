//
//  RUNButton.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNButton.h"

@interface RUNButton ()

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UILabel       *titleLabel;

@end

@implementation RUNButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setUI];
    }
    return self;
}

- (void)p_setUI {
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.top);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.titleLabel.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"";
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.imageView.bottom).offset(5);
        make.height.equalTo(21);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    self.buttonAction();
}

#pragma mark - Set Method
- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setDescStr:(NSString *)descStr {
    self.titleLabel.text = descStr;
}

@end
