//
//  RUNTransitionAnimation.m
//  RunApp
//
//  Created by Tangtang on 2016/11/12.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNTransitionAnimation.h"

@interface RUNTransitionAnimation () <CAAnimationDelegate>

@property (nonatomic, assign) RUNPresentTrasitionType   type;
@property (nonatomic, assign) RUNAnimationType          animationType;

@end

@implementation RUNTransitionAnimation

+ (instancetype)transitionWithTransitionType:(RUNPresentTrasitionType)type animationType:(RUNAnimationType)animationType {
    return [[self alloc] initWithTransitionType:type animationType:animationType];
}

- (instancetype)initWithTransitionType:(RUNPresentTrasitionType)type animationType:(RUNAnimationType)animationType {
    self = [super init];
    if (self) {
        _type = type;
        _animationType = animationType;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case RUNPresentTrasitionPresent:
            [self p_presentAnimation:transitionContext];
            break;
        case RUNPresentTrasitionDismiss:
            [self p_dismissAnimation:transitionContext];
            break;
        default:
            break;
    }
}

- (void)p_presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理者所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    if (self.animationType == RUNAnimationUpToDown) {
        
        toVC.view.frame = CGRectMake(0, -273, containerView.frame.size.width, containerView.frame.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            toVC.view.transform = CGAffineTransformMakeTranslation(0, 273);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else if (self.animationType == RUNAnimationCircle) {
        CGPoint center = CGPointMake(containerView.frame.size.width, 20);
        UIBezierPath *startCycle =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(containerView.frame.size.width - 37.5, 25, 25, 25)];
        CGFloat radius = containerView.frame.size.height / 4 * 3;
        UIBezierPath *endCycle = [UIBezierPath bezierPath];
        [endCycle moveToPoint:CGPointMake(containerView.frame.size.width, 20)];
        [endCycle addLineToPoint:CGPointMake(containerView.frame.size.width, 20 + radius)];
        [endCycle addArcWithCenter:center radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [endCycle closePath];
        //创建CAShapeLayer进行遮盖
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = endCycle.CGPath;
        //将maskLayer作为toVC.View的遮盖
        toVC.view.layer.mask = maskLayer;
        //创建路径动画
        CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
        maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
        maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
        maskLayerAnimation.duration = [self transitionDuration:transitionContext];
        maskLayerAnimation.delegate = self;
        maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
        [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    }

}

- (void)p_dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (self.animationType == RUNAnimationUpToDown) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //因为present的时候都是使用的transform，这里的动画只需要将transform恢复就可以了
            fromVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                //失败了接标记失败
                [transitionContext completeTransition:NO];
            }else{
                //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
                [transitionContext completeTransition:YES];
                
            }
        }];
    } else if (self.animationType == RUNAnimationCircle) {
        UIView *containerView = [transitionContext containerView];
        CGPoint center = CGPointMake(containerView.frame.size.width - 37.5, 25);
        CGFloat radius = containerView.frame.size.height / 4 * 3;
        UIBezierPath *startCycle = [UIBezierPath bezierPath];
        [startCycle moveToPoint:CGPointMake(containerView.frame.size.width, 20)];
        [startCycle addLineToPoint:CGPointMake(containerView.frame.size.width, 20 + radius)];
        [startCycle addArcWithCenter:center radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [startCycle closePath];
        UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(containerView.frame.size.width - 37.5, 25, 25, 25)];
        
        //创建CAShapeLayer进行遮盖
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor greenColor].CGColor;
        maskLayer.path = endCycle.CGPath;
        fromVC.view.layer.mask = maskLayer;
        //创建路径动画
        CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
        maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
        maskLayerAnimation.duration = [self transitionDuration:transitionContext];
        maskLayerAnimation.delegate = self;
        maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
        [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    }
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    switch (_type) {
        case RUNPresentTrasitionPresent:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
        }
            break;
        case RUNPresentTrasitionDismiss:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            }
        }
            break;
    }
}


@end
