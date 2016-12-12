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

@property (nonatomic, copy)     NSString    *type;
@property (nonatomic, strong)   NSDate      *date;
@property (nonatomic, copy)     NSString    *value;
@property (nonatomic, copy)     NSString    *duration;
@property (nonatomic, copy)     NSString    *kcal;
@property (nonatomic, copy)     NSString    *speed;
@property (nonatomic, copy)     NSString    *step;
@property (nonatomic, copy)     NSArray     *points;

- (void)saveDataWithHandle:(RUNHistoryData)handle;
- (void)loadDataWithFilePath:(NSString *)filePath;

@end
