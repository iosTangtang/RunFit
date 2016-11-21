//
//  UIViewController+ScreenShot.m
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "UIViewController+ScreenShot.h"

@implementation UIViewController (ScreenShot)

- (UIImage *)run_getScreenShotWithSize:(CGSize)size view:(UIView *)view {
    //开启一个图形上下文
    UIGraphicsBeginImageContext(size);
    
    //截屏
    if (![view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO]){
        NSLog(@"Failed to draw the screenshot.");
    }
    //获取当前上下文
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return screenshot;
}

@end
