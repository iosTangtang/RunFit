//
//  RUNTabBarViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/6.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNTabBarViewController.h"
#import "RUNNavigationViewController.h"

@interface RUNTabBarViewController ()

@end

@implementation RUNTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TabBar Set Method
- (void)p_addChildController:(UIViewController *)childController
                 normalImage:(UIImage *)normalImage
                 selectedImage:(UIImage *)selectedImage
                       title:(NSString *)title {
    RUNNavigationViewController *runNav = [[RUNNavigationViewController alloc] initWithRootViewController:childController];
    
    runNav.tabBarItem.image = normal;
    runNav.tabBarItem.selectedImage = selectedImage;
    runNav.tabBarItem.title = title;
    childController.title = title;
    
    [self addChildViewController:runNav];
}

@end
