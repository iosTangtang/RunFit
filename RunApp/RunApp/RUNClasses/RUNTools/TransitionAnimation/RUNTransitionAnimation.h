//
//  RUNTransitionAnimation.h
//  RunApp
//
//  Created by Tangtang on 2016/11/12.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RUNPresentTrasitionType) {
    RUNPresentTrasitionPresent,
    RUNPresentTrasitionDismiss
};

typedef NS_ENUM(NSUInteger, RUNAnimationType) {
    RUNAnimationUpToDown,
    RUNAnimationCircle
};

@interface RUNTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(RUNPresentTrasitionType)type animationType:(RUNAnimationType)animationType;
- (instancetype)initWithTransitionType:(RUNPresentTrasitionType)type animationType:(RUNAnimationType)animationType;

@end
