//
//  AppDelegate.m
//  aaaaa
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 毛睿. All rights reserved.
//

#import "AppDelegate.h"
#import "mainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:@"Yb7OXFy0jCPl4clAjS1qt9NZ1XKW06AG"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    self.mwindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    mainViewController *vc = [[mainViewController alloc]init];
    self.mwindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];;
    self.mwindow.backgroundColor = [UIColor whiteColor];
    [self.mwindow makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
