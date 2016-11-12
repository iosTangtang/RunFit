//
//  RUNCalendarViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/12.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNCalendarViewController.h"
#import "RUNTransitionAnimation.h"

@interface RUNCalendarViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIView    *clanderView;

@end

@implementation RUNCalendarViewController

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
    
    self.clanderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 273)];
    self.clanderView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.clanderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source
{
    return [RUNTransitionAnimation transitionWithTransitionType:RUNPresentTrasitionPresent animationType:RUNAnimationUpToDown];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [RUNTransitionAnimation transitionWithTransitionType:RUNPresentTrasitionDismiss animationType:RUNAnimationUpToDown];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.clanderView.frame, point)) {
        return ;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
