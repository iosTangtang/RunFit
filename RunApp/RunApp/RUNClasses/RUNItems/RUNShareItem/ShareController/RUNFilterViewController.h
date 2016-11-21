//
//  RUNFilterViewController.h
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUNFilterDelegate <NSObject>

- (void)filterImage:(UIImage *)image;

@end

@interface RUNFilterViewController : UIViewController

@property (nonatomic, strong) UIImage *imageData;
@property (nonatomic, weak)   id<RUNFilterDelegate> delegate;

@end
