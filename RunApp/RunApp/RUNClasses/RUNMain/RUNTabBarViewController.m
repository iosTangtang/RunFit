//
//  RUNTabBarViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/6.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNTabBarViewController.h"
#import "RUNNavigationViewController.h"
#import "RUNHomeViewController.h"
#import "RUNAnalazyViewController.h"
#import "RUNUserViewController.h"

@interface RUNTabBarViewController ()

@end

@implementation RUNTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UITabBar appearance].translucent = NO;
    
    [self p_setTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)p_setTabBar {
    RUNHomeViewController *homeVC = [[RUNHomeViewController alloc] init];
    [self p_addChildController:homeVC normalImage:[UIImage imageNamed:@"circle"] selectedImage:[UIImage imageNamed:@"circle_fill"] title:@"数据"];
    
    RUNAnalazyViewController *analazyVC = [[RUNAnalazyViewController alloc] init];
    [self p_addChildController:analazyVC normalImage:[UIImage imageNamed:@"rank"] selectedImage:[UIImage imageNamed:@"rank_fill"] title:@"分析"];
    
    RUNUserViewController *userVC = [[RUNUserViewController alloc] init];
    [self p_addChildController:userVC normalImage:[UIImage imageNamed:@"my"] selectedImage:[UIImage imageNamed:@"my_fill"] title:@"我"];
}

#pragma mark - TabBar Set Method
- (void)p_addChildController:(UIViewController *)childController
                 normalImage:(UIImage *)normalImage
                 selectedImage:(UIImage *)selectImage
                       title:(NSString *)title {
    RUNNavigationViewController *runNav = [[RUNNavigationViewController alloc] initWithRootViewController:childController];
    
    runNav.tabBarItem.image = normalImage;
    runNav.tabBarItem.selectedImage = selectImage;
    runNav.tabBarItem.title = title;
    childController.title = title; 
    
    self.tabBar.tintColor = [UIColor colorWithRed:93 / 255.0 green:201 / 255.0 blue:241 / 255.0 alpha:1];
    
    
    [runNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:93 / 255.0
                                                                                               green:201 / 255.0
                                                                                                blue:241 / 255.0
                                                                                               alpha:1],
                                             NSFontAttributeName:[UIFont systemFontOfSize:12.f]} forState:UIControlStateSelected];
    
    [self addChildViewController:runNav];
}

@end
