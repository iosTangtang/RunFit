//
//  YXLLineChart.m
//  Charts
//
//  Created by Tangtang on 2016/10/30.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "YXLLineChart.h"

@interface YXLLineChart (){
    CGFloat _maxLabelWidth;
}

@property (nonatomic, strong) UIView            *gradientView;
@property (nonatomic, strong) CAShapeLayer      *shapeLayer;
@property (nonatomic, strong) CAShapeLayer      *maskLayer;
@property (nonatomic, strong) UIBezierPath      *path;
@property (nonatomic, assign) int               maxData;
@property (nonatomic, assign) int               total;
@property (nonatomic, strong) UILabel           *valueLabel;
@property (nonatomic, copy)   NSMutableArray    *labels;

@end

@implementation YXLLineChart

- (UIView *)gradientView {
    if (!_gradientView) {
        _gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,
                                                                 self.bounds.size.height - confineY)];
        [self addSubview:_gradientView];
    }
    return _gradientView;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.textColor = self.valueLabelColor;
        _valueLabel.font = self.valueLabelFont;
        [self addSubview:_valueLabel];
        
    }
    return _valueLabel;
}

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maxData = 0;
        _total = 0;
        _maxLabelWidth = 0;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark Private Method
- (void)p_createDataX {
    NSUInteger number = self.heightXDatas.count;
    for (int index = 0; index < number; index++) {
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / number * index,
                                                                        self.bounds.size.height - confineY / 3.0,
                                                                        self.bounds.size.width / number, confineY / 2.0)];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.font = self.labelFont;
        monthLabel.text = self.heightXDatas[index];
        monthLabel.textColor = self.labelColor;
        [self addSubview:monthLabel];
    }
    
    if (number <= 3 && number > 1) {
        UILabel *firstLabel = [self.labels firstObject];
        firstLabel.textAlignment = NSTextAlignmentLeft;
        
        UILabel *lastLabel = [self.labels lastObject];
        lastLabel.textAlignment = NSTextAlignmentRight;
    }
}

- (void)p_createDataY {
    self.maxData = [self p_getMaxData];
    int dis = self.maxData % standardData;
    int count = (dis == 0) ? self.maxData / standardData: self.maxData / standardData + 1;
    self.total = count * standardData;
    int index = 0;
    
    CGFloat viewHeight = self.bounds.size.height - confineY;
    
    // 创建Y轴数据坐标
    for (index = 0; index < count; index++) {
        if (index != 0 && index != count && !self.showAllDashLine) {
            continue;
        }
        
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dataLabel.tag = 2000 + (index + 1);
        dataLabel.textAlignment = NSTextAlignmentCenter;
        dataLabel.font = self.labelFont;
        dataLabel.textColor = self.labelColor;
        dataLabel.text = [NSString stringWithFormat:@"%dk", (standardData / 1000) * (count - index)];
        [self addSubview:dataLabel];
        
        NSString *message = dataLabel.text;
        
        CGSize containerSize = CGSizeMake(confineX, confineY / 2.0);
        CGRect messageRect = [message boundingRectWithSize:containerSize options:NSStringDrawingUsesLineFragmentOrigin |
                              NSStringDrawingUsesFontLeading |
                              NSStringDrawingTruncatesLastVisibleLine
                                                attributes:@{NSFontAttributeName : dataLabel.font}
                                                   context:NULL];
        dataLabel.frame = CGRectMake(0, viewHeight / count * index, messageRect.size.width, ceil(messageRect.size.height));
    }
    
    [self p_drawDashLine:count height:viewHeight];
    
    self.gradientView.frame = CGRectMake(0, self.gradientView.frame.origin.y,
                                         self.gradientView.frame.size.width, self.gradientView.frame.size.height);
    [self setNeedsDisplay];
}

#pragma mark - Draw DashLine
- (void)p_drawDashLine:(int)count height:(CGFloat)viewHeight {
    if (!self.hasDashLine) {
        return ;
    }
    for (int index = 0; index <= count; index++) {
        
        if (index != 0 && index != count && !self.showAllDashLine) {
            continue;
        }
        
        UIBezierPath *dashPath = [UIBezierPath bezierPath];
        dashPath.lineWidth = 1.f;
        dashPath.lineJoinStyle = kCGLineJoinRound;
        if (index == count) {
            [dashPath moveToPoint:CGPointMake(0, viewHeight / count * index + self.lineWidth + 2)];
            [dashPath addLineToPoint:CGPointMake(self.bounds.size.width, viewHeight / count * index + self.lineWidth + 2)];
        } else {
            [dashPath moveToPoint:CGPointMake(0, viewHeight / count * index)];
            [dashPath addLineToPoint:CGPointMake(self.bounds.size.width, viewHeight / count * index)];
        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = self.dashLineColor.CGColor;
        if (index == count) {
            shapeLayer.strokeColor = self.lineColor.CGColor;
        }
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1.5f;
        shapeLayer.path = dashPath.CGPath;
        [self.gradientView.layer addSublayer:shapeLayer];
    }
}

- (void)p_drawLineChart {
    if (self.dataArray.count <= 0) {
        return ;
    }
    
    CGFloat width = self.gradientView.bounds.size.width / (double)self.dataArray.count;
    
    int index = 0, lastIndex = 0;
    for (index = 0; index < self.dataArray.count; index++) {
        int value = [self.dataArray[index] intValue];
        if (value > 0) {
            break;
        }
    }
    
    CGPoint startPoint = CGPointMake(width / 2.0 + index * width,
                                     (self.total - [self.dataArray[index] intValue]) / (double)self.total * (self.bounds.size.height - confineY));
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.lineWidth;
    self.path = path;
    [path moveToPoint:startPoint];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(width / 2.0 - self.lineWidth / 2.0 + index * width, self.bounds.size.height - confineY / 2.0 - 3)];
    [maskPath addLineToPoint:CGPointMake(startPoint.x - self.lineWidth / 2.0, startPoint.y)];
    
    for (index = index + 1; index < self.dataArray.count; index++) {
        CGFloat arc = [self.dataArray[index] intValue];
        if (arc <= 0) {
            continue;
        }
        lastIndex = index;
        CGFloat originX = width / 2.0 - pointRaduis / 2.0 + width * index;
        
        [path addLineToPoint:CGPointMake(originX + pointRaduis / 2.0, (self.total - arc) / self.total * (self.bounds.size.height - confineY))];
        [maskPath addLineToPoint:CGPointMake(originX + self.lineWidth, (self.total - arc) / self.total * (self.bounds.size.height - confineY))];
    }
    CGPoint endPoint = CGPointMake(width / 2.0 + self.lineWidth / 2.0 + lastIndex * width, self.bounds.size.height - confineY / 2.0 - 3);
    [maskPath addLineToPoint:endPoint];
    [maskPath closePath];
    
    [self p_drawMask:maskPath startPoint:startPoint endPoint:endPoint];
    [self p_drawLine:path];
    [self p_animation];
}

#pragma mark - Draw Line
- (void)p_drawLine:(UIBezierPath *)path {
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.strokeColor = self.lineColor.CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineWidth = self.lineWidth;
    self.shapeLayer.path = path.CGPath;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.gradientView.bounds;
    gradient.startPoint = CGPointMake(0.f, 0.f);
    gradient.endPoint = CGPointMake(0.f, 1.f);
    gradient.colors = self.backgroundColors;
    [gradient setLocations:@[@0,@0.8,@1]];
    [gradient setMask:self.shapeLayer];
    [self.gradientView.layer addSublayer:gradient];
}

#pragma mark - Draw Mask 
- (void)p_drawMask:(UIBezierPath *)maskPath startPoint:(CGPoint)start endPoint:(CGPoint)end {
    CGFloat height = (self.bounds.size.height - confineY / 2.0 - 3) / 2.0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(start.x - self.lineWidth / 2.0, height)];
    [path addLineToPoint:CGPointMake(end.x, height)];
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.strokeColor = [UIColor colorWithRed:217 / 255.0 green:252 / 255.0 blue:255 / 255.0 alpha:1].CGColor;
    self.maskLayer.fillColor = [UIColor clearColor].CGColor;
    self.maskLayer.path = path.CGPath;
    self.maskLayer.lineWidth = height * 2;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor = [UIColor colorWithRed:217 / 255.0 green:252 / 255.0 blue:255 / 255.0 alpha:1].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.path = maskPath.CGPath;
    [self.maskLayer setMask:layer];
    
    [self.gradientView.layer addSublayer:self.maskLayer];
}

#pragma mark - Animation
- (void)p_animation {
    if (self.hasAnimation) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basicAnimation.duration = self.animationDuration;
        basicAnimation.repeatCount = 1;
        basicAnimation.removedOnCompletion = YES;
        basicAnimation.fromValue = @0.0;
        basicAnimation.toValue = @1.0;
        [self.shapeLayer addAnimation:basicAnimation forKey:@"strokeEnd"];
        [self.maskLayer addAnimation:basicAnimation forKey:@"strokeEnd"];
    }
}

#pragma mark - Get Max Data
- (int)p_getMaxData {
    int max = 0;
    
    for (NSString *obj in self.dataArray) {
        if ([obj intValue] > max) {
            max = [obj intValue];
        }
    }
    
    return max;
}

#pragma mark Public Method
- (void)drawChart {
    self.valueLabel.textColor = self.valueLabelColor;
    self.valueLabel.font = self.valueLabelFont;
    
    [self p_createDataY];
    [self p_createDataX];
    
    [self p_drawLineChart];
    
    if (!self.hasShowValue) {
        self.valueLabel.hidden = YES;
    }
}

#pragma mark Touch Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.gradientView];
    CGRect frame;
    CGFloat width = self.gradientView.bounds.size.width / (double)self.dataArray.count;
    
    for (int index = 0 ; index < self.dataArray.count; index++) {
        CGFloat originX = width / 2.0 - pointRaduis / 2.0 + width * index;
        CGFloat arc = [self.dataArray[index] intValue];
        CGFloat height = arc / self.total * (self.bounds.size.height - confineY);
        frame = CGRectMake(originX, self.gradientView.bounds.size.height - height - self.lineWidth * 2,
                           width, height + confineY);
        NSString *value = nil;
        if (CGRectContainsPoint(frame, touchPoint)) {
            if (self.unit == YXLUnitWeak) {
                value = [NSString stringWithFormat:@"%@ : %@", self.heightXDatas[index], self.dataArray[index]];
            } else if (self.unit == YXLUnitMonth){
                value = [NSString stringWithFormat:@"%d日 : %@", index + 1, self.dataArray[index]];
            } else if (self.unit == YXLUnitDay) {
                value = [NSString stringWithFormat:@"%d时 : %@", index, self.dataArray[index]];
            } else {
                value = [NSString stringWithFormat:@"%d月 : %@", index + 1, self.dataArray[index]];
            }
            self.valueLabel.text = value;
            CGSize containerSize = CGSizeMake(self.bounds.size.width, 30);
            CGRect messageRect = [value boundingRectWithSize:containerSize options:NSStringDrawingUsesLineFragmentOrigin |
                                  NSStringDrawingUsesFontLeading |
                                  NSStringDrawingTruncatesLastVisibleLine
                                                    attributes:@{NSFontAttributeName : self.valueLabel.font}
                                                       context:NULL];
            self.valueLabel.frame = CGRectMake(self.bounds.size.width / 2.0 - messageRect.size.width / 2.0,
                                               self.gradientView.frame.origin.y - messageRect.size.height - 10,
                                               messageRect.size.width,
                                               messageRect.size.height);
            break;
        }
    }
    [self setNeedsDisplay];
}

@end
