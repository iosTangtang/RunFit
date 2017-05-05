//
//  RUNCalendarViewController.h
//  RunApp
//
//  Created by Tangtang on 2016/11/12.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RUNCalendarBlock)(NSString *);

@interface RUNCalendarViewController : UIViewController

@property (nonatomic, strong)   NSDate              *currentDate;
@property (nonatomic, copy)     RUNCalendarBlock    calendarBlock;

@end
