//
//  RUNFAQViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNFAQViewController.h"
#import "RUNFAQTableViewCell.h"

static NSString * const kFAQCell = @"kFAQCell";

@interface RUNFAQViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy)   NSArray       *messArray;

@end

@implementation RUNFAQViewController

- (NSArray *)messArray {
    if (_messArray == nil) {
        _messArray = @[@{@"question" : @"Q1:数据是从哪里来的呢?", @"answer" : @"数据是从手机的运动协处理器里面获取的哦。如果你有账号，也可以从远程服务器同步下来存到本地数据库中，作为历史记录。"},
                       @{@"question" : @"Q2:数据是怎么保存的?", @"answer" : @"应用自己维护了一个本地数据库，将检测到的数据存入本地数据库中。如果你注册了账号，可以将本地数据库的数据同步到远程服务器上哦。若发现数据有问题，可以给我们发送反馈哦。"},
                       @{@"question" : @"Q3:数据隔多久保存一次呢?", @"answer" : @"计步每隔一个小时往本地数据库保存一次。已经做好处理，不用担心数据丢失的问题。"},
                       @{@"question" : @"Q4:如果在使用过程中发现问题怎么办?", @"answer" : @"进入意见反馈给我们发邮件反馈问题哦。欢迎给我们提意见哈！"},
                       @{@"question" : @"Q5:如何联系我们呢?", @"answer" : @"我们的联系方式:\n邮箱:ios_tangtang@163.com\n欢迎给我们提供宝贵意见。"}];
    }
    return _messArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setupTableView];
}

#pragma mark - setupTableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 5.f;
    self.tableView.estimatedRowHeight = 66;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RUNFAQTableViewCell class]) bundle:nil] forCellReuseIdentifier:kFAQCell];
    
    //去掉底部线条
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RUNFAQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFAQCell];
    
    cell.titleLabel.text = [self.messArray[indexPath.row] objectForKey:@"question"];
    cell.descLabel.text = [self.messArray[indexPath.row] objectForKey:@"answer"];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
