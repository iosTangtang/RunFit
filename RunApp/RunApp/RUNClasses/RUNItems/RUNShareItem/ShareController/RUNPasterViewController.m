//
//  RUNPasterViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNPasterViewController.h"
#import "RUNPasterCollectionViewCell.h"

static NSString *const identifity = @"RUNPasterViewController";

@interface RUNPasterViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSUInteger _selectedIndex;
}

@property (nonatomic, strong)   UICollectionView    *collectionView;

@end

@implementation RUNPasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedIndex = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)p_setCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ViewWidth / 5.0, ViewHeight / 7.0);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 0);
    flowLayout.minimumInteritemSpacing = 10.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RUNPasterCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:identifity];
    
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RUNPasterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifity forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:@"sixin_img4"];
    
    if (indexPath.row == _selectedIndex) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [collectionView reloadData];
}

@end
