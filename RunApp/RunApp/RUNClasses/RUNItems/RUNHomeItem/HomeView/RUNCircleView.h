//
//  RUNCircleView.h
//  RunApp
//
//  Created by Tangtang on 2016/11/7.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUNCircleView : UIView

@property (nonatomic, assign) NSUInteger    totalStep;
@property (nonatomic, assign) NSUInteger    nowStep;
@property (nonatomic, assign) NSUInteger    animationDuration;

- (void)drawCircle;

@end
