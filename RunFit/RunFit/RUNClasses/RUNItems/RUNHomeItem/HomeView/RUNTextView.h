//
//  RUNTextView.h
//  RunApp
//
//  Created by Tangtang on 2016/11/7.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUNTextView : UIView

@property (nonatomic, assign)   NSUInteger    animationDuration;
@property (nonatomic, copy)     NSString      *mainTitle;
@property (nonatomic, strong)   UIFont        *mainTitleFont;
@property (nonatomic, copy)     NSString      *title;
@property (nonatomic, strong)   UIFont        *titleFont;
@property (nonatomic, copy)     NSString      *format;
@property (nonatomic, strong)   UIColor       *mainTitleColor;
@property (nonatomic, strong)   UIColor       *titleColor;

- (void)setLabelAnimation;

@end
