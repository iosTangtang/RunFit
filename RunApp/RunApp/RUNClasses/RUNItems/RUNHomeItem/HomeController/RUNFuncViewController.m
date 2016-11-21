//
//  RUNFuncViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/12.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNFuncViewController.h"
#import "RUNMapViewController.h"
#import "RUNTransitionAnimation.h"

static NSString * const kYearsCell = @"kChoiceCell";

@interface RUNFuncViewController () <UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy)     NSArray         *images;
@property (nonatomic, copy)     NSArray         *titles;
@property (nonatomic, strong)   UITableView     *tableView;

@end

@implementation RUNFuncViewController

- (NSArray *)images {
    if (!_images) {
        _images = @[@"run", @"fit", @"help"];
    }
    return _images;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"开始跑步", @"录入体重", @"帮助"];
    }
    return _titles;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self p_setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set Table View
- (void)p_setTableView {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:252 / 255.0 blue:252 / 255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kYearsCell];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(20);
        make.height.equalTo(3 * 55);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYearsCell forIndexPath:indexPath];
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    
    [cell setSeparatorInset:UIEdgeInsetsZero];

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        NSDictionary *dic = @{@"row" : [NSString stringWithFormat:@"%ld", indexPath.row]};
        [[NSNotificationCenter defaultCenter] postNotificationName:RUNFUNCNOTIFICATION object:nil userInfo:dic];
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source
{
    return [RUNTransitionAnimation transitionWithTransitionType:RUNPresentTrasitionPresent animationType:RUNAnimationCircle];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [RUNTransitionAnimation transitionWithTransitionType:RUNPresentTrasitionDismiss animationType:RUNAnimationCircle];
}

#pragma mark - Close Action
- (void)close:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.tableView.frame, point)) {
        return ;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
