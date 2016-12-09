//
//  AppDelegate.m
//  RunApp
//
//  Created by Tangtang on 2016/11/3.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNAppDelegate.h"
#import "RUNTabBarViewController.h"
#import "RUNNavigationViewController.h"
#import "RUNLoginViewController.h"
#import "MMPDeepSleepPreventer.h"

@interface RUNAppDelegate ()

@end

@implementation RUNAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RUNTabBarViewController *tabVC = [[RUNTabBarViewController alloc] init];
    tabVC.isRoot = YES;
    self.window.rootViewController = tabVC;
    
//    RUNLoginViewController *login = [[RUNLoginViewController alloc] init];
//    RUNNavigationViewController *nav = [[RUNNavigationViewController alloc] initWithRootViewController:login];
//    self.window.rootViewController = nav;
    
    [self.window makeKeyWindow];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[MMPDeepSleepPreventer sharedSingleton] startPreventSleep];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
