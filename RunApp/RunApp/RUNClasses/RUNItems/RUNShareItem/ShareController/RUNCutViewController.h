//
//  RUNCutViewController.h
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUNCutDelegate <NSObject>

- (void)cutImage:(UIImage *)image;

@end

@interface RUNCutViewController : UIViewController

@property (nonatomic, strong)   UIImage *imageData;
@property (nonatomic, weak)     id<RUNCutDelegate> delegate;

@end
