//
//  RUNCalendarCollectionViewCell.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNCalendarCollectionViewCell.h"

@implementation RUNCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setUI];
    }
    return self;
}

- (void)p_setUI {
    
    self.dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.dayLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1];
    [self.contentView addSubview:line];
}

@end
