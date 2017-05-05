//
//  RUNCalendarView.h
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUNCalendarDelegate <NSObject>

- (void)dayMessage:(NSString *)dayMessage;
- (void)getCalendarHeight:(CGFloat)height;

@end

@interface RUNCalendarView : UIView

@property (nonatomic, weak)     id<RUNCalendarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withCurrentDate:(NSDate *)currentDate;

@end
