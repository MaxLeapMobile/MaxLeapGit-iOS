//
//  AppDelegate.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/9/22.
//  Copyright (c) 2015年 MaxLeapMobile. All rights reserved.
//

#import "AppDelegate.h"
#import <ILSLeapCloud/ILSLeapCloud.h>
#import "MLGMLoginViewController.h"
#import "MLGMTimeLineViewController.h"
#import "MLGMRecommendViewController.h"
#import "MLGMUserPageViewController.h"
#import "MLGMNavigationController.h"
#import "MLGMTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureGlobalAppearance];
	[self configureLeapCloud];
    [self configureMagicalRecord];
    [self configureCocoaLumberjack];
    [self configureFlurry];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColorFromRGB(0xffffff);
    self.window.rootViewController = self.tabBarController = [[MLGMTabBarController alloc] init];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma Private Method
- (void)configureGlobalAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x404040),
//                                                      NSFontAttributeName : [UIFont systemFontOfSize:10]}
//                                           forState:UIControlStateNormal];
//    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x0076FF),
//                                                      NSFontAttributeName : [UIFont systemFontOfSize:10]}
//                                           forState:UIControlStateSelected];
//    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -2)];
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
//    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    
    UIImage *barLineImage = [UIImage imageWithColor:[UIColor clearColor]];
    UIImage *barBGImage = [UIImage imageWithColor:ThemeNavigationBarColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xffffff),
                                                           NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xffffff),
                                                           NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}
                                                forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBackgroundImage:barBGImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:barLineImage];
}

- (void)configureLeapCloud {
    [ILSLeapCloud setApplicationId:kMaxLeap_Application_ID clientKey:kMaxLeap_REST_API_Key];
}

- (void)configureMagicalRecord {
    [MagicalRecord setupCoreDataStack];
}

- (void)configureCocoaLumberjack {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    
    [fileLogger setMaximumFileSize:(1024 * 1024)];
    [fileLogger setRollingFrequency:(3600.0 * 24.0)];
    [[fileLogger logFileManager] setMaximumNumberOfLogFiles:7];
    [DDLog addLogger:fileLogger];
}

- (void)configureFlurry {
    [Flurry setAppVersion:kAppVersion];
    [Flurry startSession:CONFIGURE(@"3cce3f30d1c88bef1cb54f4caa09abeb64863112")];
}

@end
