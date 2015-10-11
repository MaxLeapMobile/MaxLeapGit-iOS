//
//  AppDelegate.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/9/22.
//  Copyright (c) 2015年 MaxLeap. All rights reserved.
//

#import "AppDelegate.h"
#import "DDFileLogger.h"
#import "MLGMLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureGlobalAppearance];
    [self configureMagicalRecord];
    [self configureCocoaLumberjack];
    [self configureFlurry];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColorFromRGB(0xffffff);
    [self.window makeKeyAndVisible];
    
    MLGMLoginViewController * loginVC = [[MLGMLoginViewController alloc] init];
    self.window.rootViewController = loginVC;

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
    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xbcbcbc),
                                                      NSFontAttributeName : [UIFont fontWithName:HelveticalLight size:10]}
                                           forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xff5a3b),
                                                      NSFontAttributeName : [UIFont fontWithName:HelveticalLight size:10]}
                                           forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -2)];
    UIImage *barLineImage = [UIImage imageWithColor:[UIColor clearColor]];
    UIImage *barBGImage = [UIImage imageWithColor:UIColorFromRGB(0x5d5d5d)];
    [[UITabBar appearance] setBackgroundImage:barBGImage];
    [[UITabBar appearance] setShadowImage:barLineImage];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xffffff),
                                                           NSFontAttributeName : [UIFont fontWithName:HelveticalBold size:18]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xffffff),
                                                    NSFontAttributeName : [UIFont fontWithName:HelveticalBold size:15]}
                                          forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBackgroundImage:barBGImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:barLineImage];
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
    [Flurry startSession:CONFIGURE(@"FlurryAPIKey")];
}

@end
