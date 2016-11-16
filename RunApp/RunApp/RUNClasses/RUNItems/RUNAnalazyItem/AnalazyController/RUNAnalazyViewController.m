//
//  RUNAnalazyViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/7.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNAnalazyViewController.h"
#import "RUNFuncViewController.h"
#import "RUNShareViewController.h"
#import "RUNChildViewController.h"
#import "RUNMapViewController.h"
#import "RUNFAQViewController.h"

static CGFloat const kRUNTitleH = 44;
static CGFloat const kMaxScale = 1.1;
static int const kLineWidth = 60;
static int const kMarginWidth = 116;

#define RUNButtonUnSelColor [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1]
#define RUNButtonSelColor   [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1]
#define kButtonWidth ViewWidth / 5.0

@interface RUNAnalazyViewController () <UIScrollViewDelegate> {
    NSUInteger  _currentX;
    NSArray     *_avers;
    NSArray     *_totals;
    NSArray     *_titles;
    NSArray     *_units;
    NSArray     *_chartTypes;
}

//定义头部标题
@property (nonatomic, strong) UIScrollView  *titleScroller;
@property (nonatomic, strong) UIScrollView  *containScroller;

//当前选中的标题按钮
@property (nonatomic, strong) UIButton      *selectButton;
@property (nonatomic, strong) UIView        *bottomLine;

//添加的标题按钮集合
@property (nonatomic, strong) NSMutableArray <UIButton *> *titleButtons;
@property (nonatomic, strong) NSMutableDictionary         *lineWidthCache;

@end

@implementation RUNAnalazyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setupTitleScroller];
    [self p_setupContainScroller];
    [self p_setupChildViewController];
    [self p_setupTitle];
    [self p_setNavigation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popOverWithRow:) name:RUNFUNCNOTIFICATION object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RUNFUNCNOTIFICATION object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //屏幕旋转修正containScroller的contentSize,修正到合适的大小
    self.containScroller.contentSize = CGSizeMake(self.view.frame.size.width * self.childViewControllers.count, 0);
    
    //同样是修正位置，将当前的contentOffset修正到合适的位置
    self.containScroller.contentOffset = CGPointMake(_currentX * self.view.frame.size.width, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Item
- (void)p_setNavigation {
    
    self.navigationItem.title = @"";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(leftBarItemAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"round_add"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(rightBarItemAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - Bar Item Action
- (void)leftBarItemAction:(UIBarButtonItem *)button {
    RUNShareViewController *shareVC = [[RUNShareViewController alloc] init];
    [self presentViewController:shareVC animated:YES completion:nil];
}

- (void)rightBarItemAction:(UIBarButtonItem *)button {
    RUNFuncViewController *funcVC = [[RUNFuncViewController alloc] init];
    [self presentViewController:funcVC animated:YES completion:nil];
}

#pragma mark - 设置头部标题栏
- (void)p_setupTitleScroller {
    self.titleScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, kRUNTitleH)];
    self.titleScroller.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleScroller;
    
    [self.titleScroller addSubview:self.bottomLine];
}

#pragma mark - 设置内容
- (void)p_setupContainScroller {
    
    self.containScroller = [[UIScrollView alloc] init];
    self.containScroller.backgroundColor = [UIColor whiteColor];
    self.containScroller.delegate = self;
    self.containScroller.pagingEnabled = YES;
    self.containScroller.showsHorizontalScrollIndicator = NO;
    self.containScroller.bounces = NO;
    [self.view addSubview:self.containScroller];
    
    [self.containScroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(self.view);
    }];
}

#pragma mark - 添加子控制器
- (void)p_setupChildViewController {
    
    
    for (int index = 0; index < 5; index++) {
        RUNChildViewController *workVC = [[RUNChildViewController alloc] init];
        workVC.title = self.titles[index];
        workVC.unitStr = self.units[index];
        workVC.averValue = self.avers[index];
        workVC.totalValue = self.totals[index];
        workVC.chartType = [self.chartTypes[index] intValue];
        [self addChildViewController:workVC];
    }
    
    UIView *tempView = nil;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIView *view = [self.childViewControllers objectAtIndex:i].view;
        view.backgroundColor = [UIColor whiteColor];
        [self.containScroller addSubview:view];
        
        if (i == 0) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.containScroller);
                make.width.equalTo(self.view.width);
                make.height.equalTo(self.containScroller.height);
            }];
        } else if(i == self.childViewControllers.count - 1){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(0);
                make.top.right.bottom.equalTo(self.containScroller);
                make.width.equalTo(self.view.width);
                make.height.equalTo(self.containScroller.height);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(0);
                make.top.bottom.equalTo(self.containScroller);
                make.width.equalTo(self.view.width);
                make.height.equalTo(self.containScroller.height);
            }];
        }
        tempView = view;
    }
    
}

#pragma mark - 添加标题
- (void)p_setupTitle {
    NSUInteger icount = self.childViewControllers.count;
    
    CGFloat currentX = 0;
    CGFloat width = kButtonWidth;
    CGFloat height = kRUNTitleH;
    
    for (int index = 0; index < icount; index++) {
        UIViewController *VC = self.childViewControllers[index];
        currentX = index * width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(currentX, 0, width, height);
        button.tag = index;
        
        [button setTitle:VC.title forState:UIControlStateNormal];
        [button setTitleColor:RUNButtonUnSelColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScroller addSubview:button];
        [self.titleButtons addObject:button];
        
        if (index == 0) {
            [self buttonAction:button];
        }
        
    }
    
    self.titleScroller.contentSize = CGSizeMake(icount * width, 0);
    self.titleScroller.showsHorizontalScrollIndicator = NO;
    
}

#pragma mark - 按钮点击事件
- (void)buttonAction:(UIButton *)sender {
    [self p_selectButton:sender];
    
    NSUInteger index = sender.tag;
    _currentX = index;
    
    self.containScroller.contentOffset = CGPointMake(index * ViewWidth, 0);
}

#pragma mark - 选中按钮进行的操作
- (void)p_selectButton:(UIButton *)button {
    [self.selectButton setTitleColor:RUNButtonUnSelColor forState:UIControlStateNormal];
    //将选中的button的transform重置
    self.selectButton.transform = CGAffineTransformIdentity;
    
    [button setTitleColor:RUNButtonSelColor forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(kMaxScale, kMaxScale);
    
    NSString *lineSize = [self.lineWidthCache objectForKey:button.titleLabel.text];
    
    if (!lineSize) {
        UIFont *fontWithButton = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        CGSize buttonTextSize = [button.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontWithButton, NSFontAttributeName, nil]];
        
        lineSize = [NSString stringWithFormat:@"%f", buttonTextSize.width];
    }
    
    //添加按钮下面线的移动动画
    CGFloat x = button.center.x - [lineSize doubleValue] / 2.0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomLine.frame = CGRectMake(x, self.bottomLine.frame.origin.y, [lineSize doubleValue], self.bottomLine.frame.size.height);
    } completion:nil];
    
    self.selectButton = button;
    [self p_setupButtonCenter:button];
}

#pragma mark - 将当前选中的按钮置于中心
- (void)p_setupButtonCenter:(UIButton *)button {
    CGFloat offSet = button.center.x - ViewWidth * 0.5;
    CGFloat maxOffSet = self.titleScroller.contentSize.width - (ViewWidth - kMarginWidth);
    if (offSet > maxOffSet) {
        offSet = maxOffSet;
    }
    
    if (offSet < 0) {
        offSet = 0;
    }
    
    [self.titleScroller setContentOffset:CGPointMake(offSet, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger i = self.containScroller.contentOffset.x / self.view.frame.size.width;
    [self p_selectButton:self.titleButtons[i]];
    _currentX = i;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSUInteger leftIndex = offset / ViewWidth;
    NSUInteger rightIndex = leftIndex + 1;
    
    UIButton *leftButton = self.titleButtons[leftIndex];
    UIButton *rightButton = nil;
    if (rightIndex < self.titleButtons.count) {
        rightButton = self.titleButtons[rightIndex];
    }
    
    CGFloat transScale = kMaxScale - 1;
    CGFloat rightScale = offset / self.view.frame.size.width - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    leftButton.transform = CGAffineTransformMakeScale(leftScale * transScale + 1, leftScale * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(rightScale * transScale + 1, rightScale * transScale + 1);
}

#pragma mark - NSNotification Action
- (void)popOverWithRow:(id)sender{
    NSInteger row = [[[sender userInfo] objectForKey:@"row"] integerValue];
    if (row == 0) {
        RUNMapViewController *mapVC = [[RUNMapViewController alloc] init];
        [self presentViewController:mapVC animated:YES completion:nil];
    } else if (row == 3) {
        RUNFAQViewController *faqVC = [[RUNFAQViewController alloc] init];
        faqVC.title = @"帮助";
        faqVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:faqVC animated:YES];
    }
}

#pragma mark - Lazy Load
- (NSMutableArray <UIButton *> *)titleButtons {
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
        
    }
    return _titleButtons;
}

- (NSMutableDictionary *)lineWidthCache {
    if (_lineWidthCache == nil) {
        _lineWidthCache = [NSMutableDictionary dictionary];
    }
    return _lineWidthCache;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kRUNTitleH - 2, kLineWidth, 2)];
        _bottomLine.backgroundColor = RUNButtonSelColor;
        
    }
    return _bottomLine;
}

- (NSArray *)avers {
    if (!_avers) {
        _avers = @[@"9584 步", @"55.0 公斤", @"3.2 公里", @"13 层", @"142 大卡"];
    }
    return _avers;
}

- (NSArray *)totals {
    if (!_totals) {
        _totals = @[@"67085 步", @"27.1", @"26.7 公里", @"58 层", @"456 大卡"];
    }
    return _totals;
}

- (NSArray *)units {
    if (!_units) {
        _units = @[@"总步数", @"BMI值", @"总公里", @"总楼层", @"总消耗"];
    }
    return _units;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"步数", @"体重", @"公里", @"楼层", @"卡路里"];
    }
    return _titles;
}

- (NSArray *)chartTypes {
    if (!_chartTypes) {
        _chartTypes = @[@1, @0, @1, @1, @0];
    }
    return _chartTypes;
}

@end
