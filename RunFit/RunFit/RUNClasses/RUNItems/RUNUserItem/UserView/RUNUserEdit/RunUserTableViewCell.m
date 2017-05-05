//
//  RunUserTableViewCell.m
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RunUserTableViewCell.h"

@implementation RunUserTableViewCell

+ (instancetype)cellWith:(UITableView *)tableView identifity:(NSString *)identifity {
    NSInteger index = 0;
    
    if ([identifity isEqualToString:@"RUNUserHeadCell"]) {
        index = 0;
    } else if ([identifity isEqualToString:@"RUNUserNameCell"]) {
        index = 1;
    } else if ([identifity isEqualToString:@"RUNUserNormalCell"]) {
        index = 2;
    }
    
    RunUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RunUserTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    
    return cell;
}



@end
