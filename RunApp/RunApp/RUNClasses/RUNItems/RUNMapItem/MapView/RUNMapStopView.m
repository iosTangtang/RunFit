//
//  RUNMapStopView.m
//  RunApp
//
//  Created by Tangtang on 2016/11/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNMapStopView.h"
#import "RUNMapStopCollectionViewCell.h"

static NSString *const identifity = @"RUNMapStopCollectionViewCell";

@interface RUNMapStopView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSArray *_titles;
    NSArray *_values;
}

@property (nonatomic, strong)   UICollectionView    *collectionView;

@end

@implementation RUNMapStopView

- (instancetype)initWithStopView:(BOOL)isStop {
    self = [super init];
    if (self) {
        [self p_setCollectionView];
        if (isStop) {
            [self p_setButton];
        }
    }
    return self;
}

- (void)p_setCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ViewWidth / 2.0, ViewHeight / 8.0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RUNMapStopCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:identifity];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(ViewHeight / 4.0);
    }];
}

- (void)p_setButton {
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [stopButton setTitle:@"STOP" forState:UIControlStateNormal];
    [stopButton setTitleColor:[UIColor colorWithRed:69 / 255.0 green:202 / 255.0 blue:240 / 255.0 alpha:1] forState:UIControlStateNormal];
    stopButton.layer.cornerRadius = 15;
    stopButton.layer.masksToBounds = YES;
    stopButton.layer.borderWidth = 1.f;
    stopButton.layer.borderColor = [UIColor colorWithRed:228 / 255.0 green:228 / 255.0 blue:228 / 255.0 alpha:1].CGColor;
    [stopButton addTarget:self action:@selector(p_startAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:stopButton];
    
    [stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.collectionView.bottom).equalTo(ViewHeight / 24.0 - 15);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RUNMapStopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifity forIndexPath:indexPath];
    
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.valueLabel.text = self.values[indexPath.row];
    
    return cell;
}

#pragma mark - Button Action
- (void)p_startAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(stopButtonClick:)]) {
        [self.delegate stopButtonClick:button];
    }
}


#pragma mark - Lazy Load
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"时间", @"公里", @"消耗", @"步数"];
    }
    return _titles;
}

- (NSArray *)values {
    if (!_values) {
        _values = @[@"0:00", @"2.3", @"375", @"9258"];
    }
    return _values;
}

@end
