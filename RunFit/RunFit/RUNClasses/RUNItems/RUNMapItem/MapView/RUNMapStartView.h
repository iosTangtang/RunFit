//
//  RUNMapStartView.h
//  RunApp
//
//  Created by Tangtang on 2016/11/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUNMapStartDelegate <NSObject>

- (void)startButtonClick:(NSInteger)selected;

@end

@interface RUNMapStartView : UIView

@property (nonatomic, weak) id<RUNMapStartDelegate> delegate;

@end
