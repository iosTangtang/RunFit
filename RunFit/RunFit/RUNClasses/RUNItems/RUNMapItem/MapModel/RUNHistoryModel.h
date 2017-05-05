//
//  RUNHistoryModel.h
//  RunApp
//
//  Created by Tangtang on 2016/12/11.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RUNHistoryData)(BOOL isSucceed);

@interface RUNHistoryModel : NSObject

@property (nonatomic, copy)     NSString    *id;
@property (nonatomic, copy)     NSString    *type;
@property (nonatomic, copy)     NSString    *date;
@property (nonatomic, assign)   double      value;
@property (nonatomic, copy)     NSString    *duration;
@property (nonatomic, assign)   double      kcal;
@property (nonatomic, assign)   double      speed;
@property (nonatomic, assign)   double      step;
@property (nonatomic, copy)     NSArray     *points;

- (void)saveDataWithHandle:(RUNHistoryData)handle;
- (void)dicToModel:(NSDictionary *)dic;

@end
