//
//  RUNToolViewController.h
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUNToolDelegate <NSObject>

- (void)rotateAction:(UIButton *)button;
- (void)cutAction:(UIButton *)button;

@end

@interface RUNToolViewController : UIViewController

@property (nonatomic, weak) id<RUNToolDelegate> delegate;

@end
