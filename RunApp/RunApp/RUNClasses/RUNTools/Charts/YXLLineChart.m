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
@property (nonatomic, strong) CAGradientLayer   *gradientLayer;
@property (nonatomic, strong) CAShapeLayer      *shapeLayer;
@property (nonatomic, strong) UIBezierPath      *path;
@property (nonatomic, assign) int               maxData;
@property (nonatomic, assign) int               total;
@property (nonatomic, strong) UILabel           *valueLabel;
@property (nonatomic, copy)   NSMutableArray    *labels;

@end

@implementation YXLLineChart

- (UIView *)gradientView {
    if (!_gradientView) {
        _gradientView = [[UIView alloc] initWithFrame:CGRectMake(confineX, 0, self.bounds.size.width - confineX,
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
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - _maxLabelWidth) / number * index + _maxLabelWidth,
                                                                        self.bounds.size.height - confineY / 2.0,
                                                                        (self.bounds.size.width - _maxLabelWidth) / number - 5, confineY / 2.0)];
        monthLabel.tag = 1000 + (index + 1);
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.font = self.labelFont;
        monthLabel.textColor = self.labelColor;
        monthLabel.text = self.heightXDatas[index];
        [self addSubview:monthLabel];
        
        [self.labels addObject:monthLabel];
    }
}

- (void)p_createDataY {
    self.maxData = [self p_getMaxData];
    int dis = self.maxData % standardData;
    int count = (dis == 0) ? self.maxData / standardData: self.maxData / standardData + 1;
    self.total = count * standardData;
    
    CGFloat viewHeight = self.bounds.size.height - confineY;
    
    for (int index = 0; index < count; index++) {
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
        if (_maxLabelWidth <= messageRect.size.width) {
            _maxLabelWidth = messageRect.size.width;
        }
    }
    
    //创建分割线
    for (int index = 0; index < count; index++) {
        
        if (self.hasDashLine) {
            UIBezierPath *dashPath = [UIBezierPath bezierPath];
            dashPath.lineWidth = 1.f;
            dashPath.lineJoinStyle = kCGLineJoinRound;
            [dashPath moveToPoint:CGPointMake(0, viewHeight / count * index)];
            [dashPath addLineToPoint:CGPointMake(self.bounds.size.width - _maxLabelWidth, viewHeight / count * index)];
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = self.dashLineColor.CGColor;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.lineWidth = 1.f;
            shapeLayer.path = dashPath.CGPath;
            [self.gradientView.layer addSublayer:shapeLayer];
        }
    }
    
    self.gradientView.frame = CGRectMake(_maxLabelWidth, self.gradientView.frame.origin.y,
                                         self.gradientView.frame.size.width + confineX - _maxLabelWidth, self.gradientView.frame.size.height);
    self.gradientLayer.frame = self.gradientView.bounds;
    [self setNeedsDisplay];
    
}

- (void)p_drawGrandientLayer {
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.gradientView.bounds;
    self.gradientLayer.startPoint = CGPointMake(0.f, 0.f);
    self.gradientLayer.endPoint = CGPointMake(1.f, 0.f);
    self.gradientLayer.colors = self.backgroundColors;
    [self.gradientView.layer addSublayer:self.gradientLayer];
}

- (void)p_drawLineChart {
    if (self.dataArray.count <= 0 || self.heightXDatas.count <= 0) {
        return ;
    }
    
    UILabel *label = [self viewWithTag:1001];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.lineWidth;
    self.path = path;
    [path moveToPoint:CGPointMake(label.center.x - _maxLabelWidth,
                                  (self.total - [self.dataArray[0] intValue]) / (double)self.total * (self.bounds.size.height - confineY))];
    
    UIBezierPath *firstPointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(label.center.x - _maxLabelWidth - pointRaduis / 2.0,
                                                                                 (self.total - [self.dataArray[0] intValue]) / (double)self.total *
                                                                                 (self.bounds.size.height - confineY) - pointRaduis / 2.0,
                                                                                 pointRaduis, pointRaduis) cornerRadius:pointRaduis];
    CAShapeLayer *firstPointLayer = [CAShapeLayer layer];
    firstPointLayer.path = firstPointPath.CGPath;
    firstPointLayer.strokeColor = self.lineColor.CGColor;
    firstPointLayer.fillColor = self.lineColor.CGColor;
    [self.gradientView.layer addSublayer:firstPointLayer];
    
    for (int index = 1; index < self.heightXDatas.count; index++) {
        UILabel *monthLabel = [self viewWithTag:1000 + (index + 1)];
        CGFloat arc = [self.dataArray[index] intValue];
        UIBezierPath *pointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(monthLabel.center.x - _maxLabelWidth - pointRaduis / 2.0,
                                                                                     (self.total - arc) / self.total *
                                                                                     (self.bounds.size.height - confineY) - pointRaduis / 2.0,
                                                                                     pointRaduis, pointRaduis) cornerRadius:pointRaduis];
        CAShapeLayer *pointLayer = [CAShapeLayer layer];
        pointLayer.path = pointPath.CGPath;
        pointLayer.strokeColor = self.lineColor.CGColor;
        pointLayer.fillColor = self.lineColor.CGColor;
        [self.gradientView.layer addSublayer:pointLayer];
        
        [path addLineToPoint:CGPointMake(monthLabel.center.x - _maxLabelWidth, (self.total - arc) / self.total * (self.bounds.size.height - confineY))];
    }
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.strokeColor = self.lineColor.CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineWidth = self.lineWidth;
    self.shapeLayer.path = path.CGPath;
    [self.gradientView.layer addSublayer:self.shapeLayer];
    
    if (self.hasAnimation) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basicAnimation.duration = self.animationDuration;
        basicAnimation.repeatCount = 1;
        basicAnimation.removedOnCompletion = YES;
        basicAnimation.fromValue = @0.0;
        basicAnimation.toValue = @1.0;
        [self.shapeLayer addAnimation:basicAnimation forKey:@"strokeEnd"];
    }
    
}

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
    [self p_drawGrandientLayer];
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
    
    for (int index = 0 ; index < self.heightXDatas.count; index++) {
        UILabel *obj = self.labels[index];
        frame = CGRectMake(obj.frame.origin.x - _maxLabelWidth, obj.frame.origin.y - self.gradientView.bounds.size.height,
                           obj.frame.size.width, self.gradientView.bounds.size.height);
        if (CGRectContainsPoint(frame, touchPoint)) {
            NSString *value = [NSString stringWithFormat:@"%@ : %@", self.heightXDatas[index], self.dataArray[index]];
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
