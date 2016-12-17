//
//  RUNMapStopView.h
//  RunApp
//
//  Created by Tangtang on 2016/11/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUNMapStopDelegate <NSObject>

- (void)stopButtonClick:(UIButton *)button;

@end

@interface RUNMapStopView : UIView

@property (nonatomic, weak)     id<RUNMapStopDelegate>  delegate;
@property (nonatomic, copy)     NSArray                 *datas;
@property (nonatomic, assign)   BOOL                    isRun;

- (instancetype)initWithStopView:(BOOL)isStop;

@end
