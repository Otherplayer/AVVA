//
//  AppDelegate.m
//  AVVA
//
//  Created by __无邪_ on 2017/11/29.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark -

- (void)startLaunchingAnimation {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *launchScreenView = [[UIView alloc] init];
    launchScreenView.frame = window.bounds;
    launchScreenView.backgroundColor = [UIColor cyanColor];
    [window addSubview:launchScreenView];
    
    double delayInSeconds = .05f;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    // 得到全局队列
    dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
    // 延期执行
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        [UIView animateWithDuration:.15 delay:0.9 options:MMUIViewAnimationOptionsCurveOut animations:^{
            launchScreenView.height = NavigationBarHeight + StatusBarHeight;
            launchScreenView.backgroundColor = [UIColor cyanColor];
        } completion:nil];
        [UIView animateWithDuration:1.2 delay:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
            launchScreenView.alpha = 0;
        } completion:^(BOOL finished) {
            [launchScreenView removeFromSuperview];
        }];
    });
    
}


@end
