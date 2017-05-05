//
//  RUNCloudDataBase.h
//  RunFit
//
//  Created by Tangtang on 2017/5/1.
//  Copyright © 2017年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RunCloudBlock)(BOOL isSuccessful, int status, NSError *error);

@interface RUNCloudDataBase : NSObject

- (void)updateToCloudWithBlock:(RunCloudBlock)block;

- (void)downToLocateWithBlock:(RunCloudBlock)block;

@end
