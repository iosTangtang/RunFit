//
//  RUNHistoryTableViewCell.h
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUNHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *runLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcalLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTitle;
@property (weak, nonatomic) IBOutlet UILabel *stepOrSpeed;

+ (instancetype)cellWith:(UITableView *)tableView identifity:(NSString *)identifity;

@end
