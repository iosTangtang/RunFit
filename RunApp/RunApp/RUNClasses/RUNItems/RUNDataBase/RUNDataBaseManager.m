//
//  RUNDataBaseManager.m
//  RunApp
//
//  Created by Tangtang on 2016/12/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNDataBaseManager.h"
#import "FMDB.h"

@interface RUNDataBaseManager ()

@property (nonatomic, strong)   FMDatabase  *dataBase;

@end

@implementation RUNDataBaseManager

- (BOOL)run_openDataBaseWithFilePath:(NSString *)filePath {
    self.dataBase = [FMDatabase databaseWithPath:filePath];
    if ([self.dataBase open]) {
        return YES;
    }
    return NO;
}

@end
