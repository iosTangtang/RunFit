//
//  RUNUserHeadView.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNUserHeadView.h"
#import "RUNTextView.h"
#import "UIImageView+WebCache.h"

@interface RUNUserHeadView ()

@property (nonatomic, strong) UILabel           *userNameLabel;
@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) RUNTextView       *heightLabel;
@property (nonatomic, strong) RUNTextView       *weightLabel;
@property (nonatomic, strong) RUNTextView       *bmiLabel;
@property (nonatomic, strong) RUNTextView       *targetLabel;
@property (nonatomic, copy)   NSArray           *dataArray;
@property (nonatomic, strong) NSMutableArray    *labelArray;

@end

@implementation RUNUserHeadView

#pragma mark - Init Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setBackground];
        [self p_setUI];
        [self p_setMessageUI];
        [self p_addGesture];
    }
    return self;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"身高", @"体重", @"BMI", @"目标"];
    }
    return _dataArray;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

#pragma mark - Set UI Method
- (void)p_setBackground {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.startPoint = CGPointMake(0.f, 0.f);
    gradient.endPoint = CGPointMake(0.f, 1.f);
    gradient.colors = @[(__bridge id)[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1].CGColor,
                        (__bridge id)[UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor];
    [gradient setLocations:@[@0, @0.8, @1]];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor;
    shapeLayer.fillColor = [UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    
    [gradient setMask:shapeLayer];
    [self.layer addSublayer:gradient];
}

- (void)p_setUI {
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"Oval 3"];
    self.imageView.layer.cornerRadius = ViewHeight / 12.0;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY);
        make.width.height.equalTo(ViewHeight / 6.0);
    }];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.text = @"未命名";
    self.userNameLabel.font = [UIFont systemFontOfSize:ViewHeight / 30.f];
    [self addSubview:self.userNameLabel];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.bottom.equalTo(self.imageView.top).offset(-ViewHeight / 25.f);
        make.height.equalTo(30);
    }];
    
}

- (void)p_setMessageUI {
    
    for (int index = 0; index < 4; index++) {
        RUNTextView *label = [[RUNTextView alloc] initWithFrame:CGRectZero];
        label.mainTitle = self.dataArray[index];
        label.title = @"- -";
        label.mainTitleFont = [UIFont systemFontOfSize:17.f];
        label.titleFont = [UIFont fontWithName:@"Helvetica" size:17.f];
        label.mainTitleColor = [UIColor whiteColor];
        label.titleColor = [UIColor whiteColor];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom).offset(-20);
            make.width.equalTo(ViewWidth / 4.0);
            make.height.equalTo(50);
            make.left.equalTo(self.left).offset(ViewWidth / 4.0 * index);
        }];
        
        [self.labelArray addObject:label];
    }
    
}

- (void)p_addGesture {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(p_headClickButtonAction)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
}

#pragma mark - Head View Click Action
- (void)p_headClickButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeadClick)]) {
        [self.delegate userHeadClick];
    }
}

#pragma mark - Set Method
- (void)setUserName:(NSString *)name {
    self.userNameLabel.text = name;
}

- (void)setUserImageWithUrl:(NSString *)url placeholderImage:(UIImage *)image {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image];
}

- (void)setUserHeight:(CGFloat)height {
    if (self.labelArray <= 0) {
        return;
    }
    RUNTextView *label = self.labelArray[0];
    label.title = [NSString stringWithFormat:@"%.1f", height];
}

- (void)setUserWeight:(CGFloat)weight {
    if (self.labelArray <= 0) {
        return;
    }
    RUNTextView *label = self.labelArray[1];
    label.title = [NSString stringWithFormat:@"%.1f", weight];
}

- (void)setUserBMI:(CGFloat)bmi {
    if (self.labelArray <= 0) {
        return;
    }
    RUNTextView *label = self.labelArray[2];
    label.title = [NSString stringWithFormat:@"%.1f", bmi];
}

- (void)setUserTarget:(NSInteger)target {
    if (self.labelArray <= 0) {
        return;
    }
    RUNTextView *label = self.labelArray[3];
    label.title = [NSString stringWithFormat:@"%zd", target];
}

@end
