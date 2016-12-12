//
//  RUNCalendarView.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNCalendarView.h"
#import "RUNCalendarCollectionViewCell.h"

static NSString *const identifier = @"calendar";
static CGFloat  const animationDuration = 0.35f;

@interface RUNCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)   UICollectionView    *collectionView;
@property (nonatomic, strong)   NSCalendar          *calendar;
@property (nonatomic, copy)     NSArray             *weakTitles;
@property (nonatomic, strong)   UILabel             *showLabel;
@property (nonatomic, strong)   UIView              *headView;
@property (nonatomic, strong)   NSDate              *currentDate;
@property (nonatomic, strong)   NSDate              *selectedDate;

@end

@implementation RUNCalendarView

#pragma mark - Lazy Load
- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSArray *)weakTitles {
    if (!_weakTitles) {
        _weakTitles = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    }
    return _weakTitles;
}

#pragma mark - Init Method
- (instancetype)initWithFrame:(CGRect)frame withCurrentDate:(NSDate *)currentDate {
    self = [super initWithFrame:frame];
    if (self) {
        _currentDate = currentDate;
        _selectedDate = currentDate;
        [self p_setupLabelAndButton];
        [self p_setupCollectionView];
    }
    return self;
}

#pragma mark - Set UI Method
- (void)p_setupLabelAndButton {
    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.headView];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.top).offset(20);
        make.height.equalTo(30);
    }];
    
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [preButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [preButton setTintColor:[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1]];
    [preButton addTarget:self action:@selector(p_preButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:preButton];
    
    [preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.centerY);
        make.left.equalTo(self.headView.left).offset(20);
        make.width.height.equalTo(20);
    }];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [nextButton setTintColor:[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1]];
    [nextButton addTarget:self action:@selector(p_nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.centerY);
        make.right.equalTo(self.headView.right).offset(-20);
        make.width.height.equalTo(20);
    }];
    
    self.showLabel = [[UILabel alloc] init];
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    self.showLabel.textColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
    self.showLabel.text = [self p_stringFromDate:self.currentDate];
    [self.headView addSubview:self.showLabel];
    
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView.centerX);
        make.centerY.equalTo(self.headView.centerY);
        make.width.equalTo(120);
        make.height.equalTo(25);
    }];
}

- (void)p_setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ViewWidth / 7.0, 35);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[RUNCalendarCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.bottom);
        make.left.bottom.right.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.weakTitles.count;
    }
    
    NSInteger days = [self p_daysOfMonth];
    NSInteger firstWeekDay = [self p_weakOfDay];
    
    if ([self.delegate respondsToSelector:@selector(getCalendarHeight:)]) {
        NSInteger colum = (days + firstWeekDay) / 7.0;
        colum = (days + firstWeekDay) % 7 == 0 ? colum : colum + 1;
        [self.delegate getCalendarHeight:(colum + 1) * 35 + 50];
    }
    
    return days + firstWeekDay;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RUNCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.dayLabel.textColor = [UIColor colorWithRed:155 / 255.0 green:155 / 255.0 blue:155 / 255.0 alpha:1];
    if (indexPath.section == 0) {
        cell.dayLabel.text = self.weakTitles[indexPath.row];
        cell.dayLabel.font = [UIFont systemFontOfSize:14.f];
        cell.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    }
    else {
        NSInteger days = [self p_daysOfMonth];
        NSInteger firstWeekDay = [self p_weakOfDay];
        
        if ((indexPath.row < firstWeekDay) || (indexPath.row > days + firstWeekDay - 1)) {
            cell.dayLabel.text = @"";
        }
        else {
            NSInteger day = indexPath.row - firstWeekDay + 1;
            cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
            NSString *str = [NSString stringWithFormat:@"%.2ld", day];
            NSString *dateStr = [NSString stringWithFormat:@"%@%@日", [self p_stringFromDate:self.currentDate], str];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy年MM月dd日";
            NSString *currentStr = [formatter stringFromDate:[self p_getCurrentDate]];
            NSString *nowDateStr = [formatter stringFromDate:self.selectedDate];
            
            if ([currentStr isEqualToString:dateStr]) {
                cell.dayLabel.textColor = [UIColor colorWithRed:7 / 255.0 green:151 / 255.0 blue:215 / 255.0 alpha:1];
            }
            
            if ([nowDateStr isEqualToString:dateStr]) {
                cell.dayLabel.textColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
            }
            
        }
        cell.dayLabel.font = [UIFont systemFontOfSize:17.f];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RUNCalendarCollectionViewCell *cell = (RUNCalendarCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section != 0 && ![cell.dayLabel.text isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(dayMessage:)]) {
            RUNCalendarCollectionViewCell *cell = (RUNCalendarCollectionViewCell *)[self collectionView:collectionView
                                                                                 cellForItemAtIndexPath:indexPath];
            NSString *message = [[self p_stringFromDate:self.currentDate]
                                 stringByAppendingString:[NSString stringWithFormat:@"%@日", cell.dayLabel.text]];
            [self.delegate dayMessage:message];
        }
    }
}

#pragma mark - Button Action
- (void)p_preButtonAction:(UIButton *)button {
    [UIView transitionWithView:self duration:animationDuration options:UIViewAnimationOptionTransitionCurlDown animations:^{
        self.currentDate = [self p_preMonthWithDate:self.currentDate];
        self.showLabel.text = [self p_stringFromDate:self.currentDate];
        [self.collectionView reloadData];
    } completion:nil];
}

- (void)p_nextButtonAction:(UIButton *)button {
    [UIView transitionWithView:self duration:animationDuration options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.currentDate = [self p_nextMonthWithDate:self.currentDate];
        self.showLabel.text = [self p_stringFromDate:self.currentDate];
        [self.collectionView reloadData];
    } completion:nil];
}

#pragma mark - DateFormater
- (NSString *)p_stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月";
    return [formatter stringFromDate:date];
}

- (NSDate *)p_dateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    return [formatter dateFromString:string];
}

#pragma mark - Calendar Method
- (NSInteger)p_daysOfMonth {
    return [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.currentDate].length;
}

- (NSDate *)p_firstDayOfMonth {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self.currentDate];
    components.day = 1;
    return [self.calendar dateFromComponents:components];
}

- (NSInteger)p_weakOfDay {
    return [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:[self p_firstDayOfMonth]] - 1;
}

- (NSDate *)p_preMonthWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)p_nextMonthWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = +1;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)p_getCurrentDate {
    return [NSDate date];
}

@end
