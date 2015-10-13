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
//    [self configureGlobalAppearance];
	[self configureLeapCloud];
    [self configureMagicalRecord];
    [self configureCocoaLumberjack];
    [self configureFlurry];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColorFromRGB(0xffffff);
    self.window.rootViewController = self.tabBarController;
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

#pragma mark Getter Setter Method
- (UITabBarController *)tabBarController {
    if (!_tabBarController) {
        MLGMTabBarController *tabController = [[MLGMTabBarController alloc] init];
        __weak typeof(self) wSelf = self;
        tabController.centralButtonAction = ^{
            UIViewController *vcRecommend = [[MLGMRecommendViewController alloc] init];
            UINavigationController *navRecommend = [[MLGMNavigationController alloc] initWithRootViewController:vcRecommend];
            navRecommend.title = vcRecommend.title = NSLocalizedString(@"Recommend", @"");
            [wSelf.tabBarController presentViewController:navRecommend animated:YES completion:nil];
        };
  
        UIViewController *vc1 = [[MLGMTimeLineViewController alloc] init];
        UINavigationController *nav1 = [[MLGMNavigationController alloc] initWithRootViewController:vc1];
        nav1.title = vc1.title = NSLocalizedString(@"TimeLine", @"");
        [nav1.tabBarItem setImage:ImageNamed(@"timeline_icon_normal")];
        [nav1.tabBarItem setSelectedImage:ImageNamed(@"timeline_icon_selected")];
        
        UIViewController *vc2 = [[UIViewController alloc] init];
        
        UIViewController *vc3 = [[MLGMUserPageViewController alloc] init];
        UINavigationController *nav3 = [[MLGMNavigationController alloc] initWithRootViewController:vc3];
        nav3.title = vc3.title = NSLocalizedString(@"Mine", @"");
        [vc3.tabBarItem setImage:ImageNamed(@"mine_icon_normal")];
        [vc3.tabBarItem setSelectedImage:ImageNamed(@"mine_icon_selected")];
        
        _tabBarController = tabController;
        _tabBarController.viewControllers = @[nav1, vc2, nav3];
    }
    
    return _tabBarController;
}

@end
