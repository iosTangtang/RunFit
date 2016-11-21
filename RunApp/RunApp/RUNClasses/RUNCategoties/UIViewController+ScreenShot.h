//
//  UIViewController+ScreenShot.h
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ScreenShot)

- (UIImage *)run_getScreenShotWithSize:(CGSize)size view:(UIView *)view;

@end
