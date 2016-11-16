//
//  RUNPickViewController.h
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUNPickerViewDelegate <NSObject>

- (void)pickText:(NSString *)text;

@end

@interface RUNPickViewController : UIViewController

@property (nonatomic, strong) id<RUNPickerViewDelegate> pickDelegate;
@property (nonatomic, copy)   NSArray                   *datas;
@property (nonatomic, copy)   NSString                  *mainTitle;
@property (nonatomic, copy)   UIColor                   *backGroundColor;
@property (nonatomic, copy)   NSString                  *separator;

@end
