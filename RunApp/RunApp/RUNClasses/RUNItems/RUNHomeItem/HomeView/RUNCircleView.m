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

@interface RUNCircleView () {
    NSString *_oldStep;
}

@property (nonatomic, strong) CAShapeLayer      *shapeLayer;
@property (nonatomic, strong) CAShapeLayer      *circleLayer;
@property (nonatomic, strong) CAGradientLayer   *gradientLayer;
@property (nonatomic, strong) UICountingLabel   *stepLabel;
@property (nonatomic, strong) UILabel           *totalLabel;

@end

@implementation RUNCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _oldStep = @"0";
        self.backgroundColor = [UIColor clearColor];
        [self p_setLabel];
        [self p_drawCircle];
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
    
    self.stepLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.stepLabel.textAlignment = NSTextAlignmentCenter;
    self.stepLabel.textColor = [UIColor colorWithRed:12 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
    self.stepLabel.font = [UIFont fontWithName:@"Helvetica" size:ViewHeight / 16.f];
    self.stepLabel.method = UILabelCountingMethodLinear;
    self.stepLabel.format = @"%d";
    [self addSubview:self.stepLabel];
    
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.totalLabel.textColor = [UIColor lightGrayColor];
    self.totalLabel.font = [UIFont systemFontOfSize:12.f];
    self.totalLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.totalLabel];
    
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
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
}

#pragma mark - Animation Method
- (void)p_circleAnimation:(BOOL)animation nowStep:(NSUInteger)nowStep {
    if (animation == NO) {
        return;
    }
    
    self.shapeLayer.strokeEnd = nowStep > self.totalStep ? 1 : nowStep / (double)self.totalStep;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.duration = self.animationDuration;
    basicAnimation.repeatCount = 1;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation.removedOnCompletion = YES;
    basicAnimation.fromValue = @([_oldStep integerValue] > self.totalStep ? 1 : [_oldStep integerValue] / (double)self.totalStep);
    basicAnimation.toValue = @(nowStep > self.totalStep ? 1 : nowStep / (double)self.totalStep);
    [self.shapeLayer addAnimation:basicAnimation forKey:@"strokeEnd"];
}

#pragma mark - Set Method
- (void)setNowStep:(NSString *)nowStep {
    _oldStep = _nowStep;
    _nowStep = nowStep;
    self.stepLabel.text = nowStep;
    [self.stepLabel countFrom:[_oldStep integerValue] to:[nowStep integerValue] withDuration:self.animationDuration];
    [self.shapeLayer removeAllAnimations];
    [self p_circleAnimation:YES nowStep:[nowStep integerValue]];
}

- (void)setTotalStep:(NSUInteger)totalStep {
    _totalStep = totalStep;
    self.totalLabel.text = [NSString stringWithFormat:@"目标: %ld", (long)totalStep];
}

@end
