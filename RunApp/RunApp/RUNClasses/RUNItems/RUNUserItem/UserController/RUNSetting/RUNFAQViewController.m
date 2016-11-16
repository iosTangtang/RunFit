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
        _messArray = @[@{@"question" : @"Q1:数据是从哪里来的呢?", @"answer" : @"如果开启健康同步的话，数据是从健康中获取的，否则是应用自己统计的。"},
                       @{@"question" : @"Q2:数据是怎么保存的?", @"answer" : @"开启健康同步的话，应用统计的数据同时也写入了健康中。若没有登录，数据保留在本地，否则保留在自身的应用服务器上。"},
                       @{@"question" : @"Q3:如果在使用过程中发现问题怎么办?", @"answer" : @"进入意见反馈给我们发邮件反馈问题哦。欢迎给我们提意见哈！"}];
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
