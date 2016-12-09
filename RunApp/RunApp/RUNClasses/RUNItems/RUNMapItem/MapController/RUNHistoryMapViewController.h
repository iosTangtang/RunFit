//
//  RUNHistoryMapViewController.h
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUNHistoryMapViewController : UIViewController

@property (nonatomic, assign) BOOL      isToRoot;
@property (nonatomic, assign) BOOL      isRun;
@property (nonatomic, copy)   NSArray   *datas;
@property (nonatomic, copy)   NSArray   *lineDatas;

@end
