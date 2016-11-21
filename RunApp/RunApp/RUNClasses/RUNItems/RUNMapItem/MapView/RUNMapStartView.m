//
//  RUNMapStartView.m
//  RunApp
//
//  Created by Tangtang on 2016/11/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNMapStartView.h"
#import "RUNMapStartTableViewCell.h"

@interface RUNMapStartView () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *_titles;
    NSArray *_images;
}

@property (nonatomic, strong)   UITableView         *tableView;
@property (nonatomic, strong)   NSMutableArray      *selectedArray;

@end

@implementation RUNMapStartView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self p_setUI];
    }
    return self;
}

- (void)p_setUI {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RUNMapStartTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"RUNMapStartView"];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RUNMapStartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RUNMapStartView"];
    
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    cell.textLabel.text = self.titles[indexPath.row];
    BOOL isSelected = [self.selectedArray[indexPath.row] boolValue];
    if (isSelected) {
        cell.checkImage.image = [UIImage imageNamed:@"round_check_fill"];
    } else {
        cell.checkImage.image = [UIImage imageNamed:@"round_check"];
    }
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ViewHeight / 9.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return ViewHeight / 9.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (int index = 0; index < self.selectedArray.count; index++) {
        if (index == indexPath.row) {
            [self.selectedArray replaceObjectAtIndex:index withObject:@1];
        } else {
            [self.selectedArray replaceObjectAtIndex:index withObject:@0];
        }
    }
    
    [tableView reloadData];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bakeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight / 9.0)];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton setTitle:@"GO" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor colorWithRed:69 / 255.0 green:202 / 255.0 blue:240 / 255.0 alpha:1] forState:UIControlStateNormal];
    startButton.layer.cornerRadius = 15;
    startButton.layer.masksToBounds = YES;
    startButton.layer.borderWidth = 1.f;
    startButton.layer.borderColor = [UIColor colorWithRed:228 / 255.0 green:228 / 255.0 blue:228 / 255.0 alpha:1].CGColor;
    [startButton addTarget:self action:@selector(p_startAction:) forControlEvents:UIControlEventTouchUpInside];
    [bakeView addSubview:startButton];
    
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bakeView.centerX);
        make.centerY.equalTo(bakeView.centerY);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:228 / 255.0 green:228 / 255.0 blue:228 / 255.0 alpha:1];
    [bakeView addSubview:lineView];
    
    return bakeView;
}

#pragma mark - Button Action
- (void)p_startAction:(UIButton *)button {
    __block NSInteger index = 0;
    [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] == 1) {
            index = idx;
        }
    }];
    if ([self.delegate respondsToSelector:@selector(startButtonClick:)]) {
        [self.delegate startButtonClick:index];
    }
}

#pragma mark - Set Method
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [self addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - Lazy Load
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"步行/跑步", @"骑行"];
    }
    return _titles;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"run-history", @"bike"];
    }
    return _images;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithArray:@[@1, @0]];
    }
    return _selectedArray;
}

@end
