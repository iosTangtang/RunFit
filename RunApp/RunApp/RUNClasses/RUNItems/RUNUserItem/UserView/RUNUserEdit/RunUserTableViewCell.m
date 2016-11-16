//
//  RunUserTableViewCell.m
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RunUserTableViewCell.h"

@implementation RunUserTableViewCell

+ (instancetype)cellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    NSInteger index = 0;
    
    if (indexPath.row == 0) {
        identifier = @"RUNUserHeadCell";
        index = 0;
    } else if (indexPath.row == 1) {
        identifier = @"RUNUserNameCell";
        index = 1;
    } else {
        identifier = @"RUNUserNormalCell";
        index = 2;
    }
    
    RunUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RunUserTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    
    return cell;
}



@end
