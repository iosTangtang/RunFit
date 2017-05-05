//
//  RUNTabBarViewController.h
//  RunApp
//
//  Created by Tangtang on 2016/11/6.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUNTabBarViewController : UITabBarController

@property (nonatomic, assign) BOOL  isRoot;

- (void)addChildController:(UIViewController *)childController
               normalImage:(UIImage *)normalImage
             selectedImage:(UIImage *)selectImage
                     title:(NSString *)title;

@end
