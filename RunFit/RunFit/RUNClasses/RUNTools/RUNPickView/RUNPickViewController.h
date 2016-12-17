//
//  RUNPickViewController.h
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUNPickerViewDelegate <NSObject>

@optional
- (void)pickText:(NSString *)text;
- (void)pickText:(NSString *)text withRow:(NSUInteger)row;

@end

@interface RUNPickViewController : UIViewController

@property (nonatomic, strong) id<RUNPickerViewDelegate> pickDelegate;
@property (nonatomic, copy)   NSArray                   *datas;
@property (nonatomic, copy)   NSString                  *mainTitle;
@property (nonatomic, copy)   UIColor                   *backGroundColor;
@property (nonatomic, copy)   NSString                  *separator;
@property (nonatomic, assign) BOOL                      isTime;
@property (nonatomic, assign) BOOL                      isDate;
@property (nonatomic, copy)   NSArray <NSNumber *>      *dValue;
@property (nonatomic, copy)   NSArray                   *defaultData;
@property (nonatomic, assign) NSUInteger                row;

@end
