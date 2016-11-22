//
//  RUNHistoryTableViewCell.m
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNHistoryTableViewCell.h"

@implementation RUNHistoryTableViewCell

+ (instancetype)cellWith:(UITableView *)tableView identifity:(NSString *)identifity {
    int index;
    if ([identifity isEqualToString:@"RUNWeightCell"]) {
        index = 1;
    } else {
        index = 0;
    }
    
    RUNHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RUNHistoryTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    
    return cell;
}

@end
