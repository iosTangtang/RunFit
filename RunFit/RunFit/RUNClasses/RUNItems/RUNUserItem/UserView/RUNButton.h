//
//  RUNButton.h
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RUNButtonAction)(void);

@interface RUNButton : UIView

@property (nonatomic, strong) UIImage           *image;
@property (nonatomic, copy)   NSString          *descStr;
@property (nonatomic, copy)   RUNButtonAction   buttonAction;

@end
