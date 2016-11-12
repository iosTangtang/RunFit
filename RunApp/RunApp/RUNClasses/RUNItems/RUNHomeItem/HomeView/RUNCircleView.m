//
//  RUNCircleView.m
//  RunApp
//
//  Created by Tangtang on 2016/11/7.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNCircleView.h"
#import "UICountingLabel.h"

static int const circleWidth = 13;

@interface RUNCircleView ()

@property (nonatomic, strong) CAShapeLayer      *shapeLayer;
@property (nonatomic, strong) CAShapeLayer      *circleLayer;
@property (nonatomic, strong) CAGradientLayer   *gradientLayer;
@property (nonatomic, strong) UICountingLabel   *stepLabel;

@end

@implementation RUNCircleView

- (UILabel *)stepLabel {
    if (!_stepLabel) {
        _stepLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
        _stepLabel.textAlignment = NSTextAlignmentCenter;
        _stepLabel.textColor = [UIColor colorWithRed:12 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
        _stepLabel.font = [UIFont fontWithName:@"Helvetica" size:ViewHeight / 16.f];
        _stepLabel.method = UILabelCountingMethodLinear;
        _stepLabel.format = @"%d";
    }
    return _stepLabel;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Set Label
- (void)p_setLabel {
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLable.text = @"今日步数";
    titleLable.textColor = [UIColor lightGrayColor];
    titleLable.font = [UIFont systemFontOfSize:14.f];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLable];
    
    [self.stepLabel countFrom:0 to:self.nowStep withDuration:self.animationDuration];
    
    [self addSubview:self.stepLabel];
    
    UILabel *totalLable = [[UILabel alloc] initWithFrame:CGRectZero];
    totalLable.text = [NSString stringWithFormat:@"目标: %ld", (long)self.totalStep];
    totalLable.textColor = [UIColor lightGrayColor];
    totalLable.font = [UIFont systemFontOfSize:12.f];
    totalLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalLable];
    
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(40);
        make.width.equalTo(self);
    }];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.stepLabel.top).offset(-5);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(21);
    }];
    
    [totalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepLabel.bottom).offset(5);
        make.centerX.height.width.equalTo(titleLable);
    }];
}

#pragma mark - Draw View
- (void)p_drawCircle {
    //灰色部分
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:self.bounds.size.width / 2.0 - circleWidth / 2.0
                                                             startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.frame = CGRectMake(0, 0, self.bounds.size.width + circleWidth,
                                        self.bounds.size.height + circleWidth);
    self.circleLayer.path = circlePath.CGPath;
    self.circleLayer.lineWidth = circleWidth;
    self.circleLayer.strokeColor = [UIColor colorWithRed:227 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:0.6].CGColor;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.circleLayer];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.circleLayer.frame;
    self.shapeLayer.path = circlePath.CGPath;
    self.shapeLayer.lineWidth = circleWidth;
    self.shapeLayer.strokeColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1].CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeEnd = self.nowStep > self.totalStep ? 1 : self.nowStep / (double)self.totalStep;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineCap = kCALineCapRound;
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.shapeLayer.frame;
    self.gradientLayer.startPoint = CGPointMake(0.f, 0.f);
    self.gradientLayer.endPoint = CGPointMake(1.f, 0.f);
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1].CGColor,
                                  (__bridge id)[UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor];
    [self.gradientLayer setLocations:@[@0,@0.55,@1]];
    [self.gradientLayer setMask:self.shapeLayer];
    [self.layer addSublayer:self.gradientLayer];
    
    [self p_circleAnimation:YES];
}

#pragma mark - Animation Method
- (void)p_circleAnimation:(BOOL)animation {
    if (animation == NO) {
        return;
    }
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.duration = self.animationDuration;
    basicAnimation.repeatCount = 1;
    basicAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation.removedOnCompletion = YES;
    basicAnimation.fromValue = @0.0;
    basicAnimation.toValue = @(self.nowStep > self.totalStep ? 1 : self.nowStep / (double)self.totalStep);
    [self.shapeLayer addAnimation:basicAnimation forKey:@"strokeEnd"];
}

#pragma mark - Public Method
- (void)drawCircle {
    [self p_setLabel];
    
    [self p_drawCircle];
}

@end
