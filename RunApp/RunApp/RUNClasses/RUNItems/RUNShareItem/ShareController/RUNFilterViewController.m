//
//  RUNFilterViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNFilterViewController.h"
#import "RUNFilterCollectionViewCell.h"
#import "UIImage+Filter.h"

static NSString *const identifity = @"RUNFilterViewController";

@interface RUNFilterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    NSArray *_titles;
    NSUInteger _selectedIndex;
}

@property (nonatomic, strong)   UICollectionView    *collectionView;
@property (nonatomic, copy)     NSArray             *filters;
@property (nonatomic, strong)   NSMutableDictionary *filterDic;

@end

@implementation RUNFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedIndex = 0;
    
    [self p_loadFilter];
    
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RUNFilterCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:identifity];
    
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RUNFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifity forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [self.filterDic objectForKey:@(indexPath.row)];
    cell.descLabel.text = self.titles[indexPath.row];
    cell.descLabel.textColor = [UIColor colorWithRed:66 / 255.0 green:66 / 255.0 blue:66 / 255.0 alpha:1];
    
    if (indexPath.row == _selectedIndex) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
        cell.descLabel.textColor = [UIColor whiteColor];
    }

    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(filterImage:)]) {
        [self.delegate filterImage:[self.filterDic objectForKey:@(indexPath.row)]];
    }
}

#pragma mark - Cache
//- (UIImage *)p_getFilterImage:(NSUInteger)row {
//    __block UIImage *image = [self.filterDic objectForKey:@(row)];
//    
//    if (!image) {
//        image = [self.imageData addFilter:self.filters[row]];
//        [self.filterDic setObject:image forKey:@(row)];
//    }
//    
//    return image;
//}

#pragma mark - Set Method
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"无", @"单色", @"色调", @"黑白", @"褪色", @"铬黄", @"冲印", @"岁月", @"怀旧"];
    }
    return _titles;
}

- (NSArray *)filters {
    if (!_filters) {
        _filters = @[@"OriginImage", @"CIPhotoEffectMono", @"CIPhotoEffectTonal", @"CIPhotoEffectNoir",
                      @"CIPhotoEffectFade", @"CIPhotoEffectChrome", @"CIPhotoEffectProcess",
                     @"CIPhotoEffectTransfer", @"CIPhotoEffectInstant"];
    }
    return _filters;
}

- (NSMutableDictionary *)filterDic {
    if (!_filterDic) {
        _filterDic = [NSMutableDictionary dictionary];
    }
    return _filterDic;
}

#pragma mark - Load Filter
- (void)p_loadFilter {
    __block UIImage *image = nil;
    [self.filters enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        image = [self.imageData addFilter:self.filters[idx]];
        [self.filterDic setObject:image forKey:@(idx)];
    }];
}

@end
