//
//  AppDelegate.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/9/22.
//  Copyright (c) 2015年 MaxLeapMobile. All rights reserved.
//

#import "AppDelegate.h"
#import "MLGMLoginViewController.h"
#import "MLGMTimeLineViewController.h"
#import "MLGMRecommendViewController.h"
#import "MLGMMyPageViewController.h"
#import "MLGMNavigationController.h"

@interface AppDelegate () <UITabBarControllerDelegate>
@property (nonatomic, assign) NSUInteger selectedControllerIndex;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureGlobalAppearance];
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

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIViewController *recommendController = self.tabBarController.viewControllers[1];
    if (viewController == recommendController) {
        NSUInteger currentlySelectedIndex = tabBarController.selectedIndex;
        UIViewController *vcRecommend = [[MLGMRecommendViewController alloc] init];
        UINavigationController *navRecommend = [[MLGMNavigationController alloc] initWithRootViewController:vcRecommend];
        navRecommend.title = vcRecommend.title = NSLocalizedString(@"Recommend", @"");
        [tabBarController presentViewController:navRecommend animated:YES completion:^{
            [tabBarController setSelectedIndex:currentlySelectedIndex];
        }];
        return NO;
    }
    
    return YES;
}

#pragma mark Getter Setter Method
- (UITabBarController *)tabBarController {
    if (!_tabBarController) {
        _tabBarController = [[UITabBarController alloc] init];
        UIViewController *vc1 = [[MLGMTimeLineViewController alloc] init];
        UINavigationController *nav1 = [[MLGMNavigationController alloc] initWithRootViewController:vc1];
        nav1.title = vc1.title = NSLocalizedString(@"TimeLine", @"");
        
        UIViewController *vc2 = [[MLGMTimeLineViewController alloc] init];
        UINavigationController *nav2 = [[MLGMNavigationController alloc] initWithRootViewController:vc2];
        vc2.title = NSLocalizedString(@"TimeLine", @"");
        nav2.title = NSLocalizedString(@"Recommend", @"");
        
        UIViewController *vc3 = [[MLGMMyPageViewController alloc] init];
        vc3.title = NSLocalizedString(@"Mine", @"");
        
        _tabBarController.viewControllers = @[nav1, nav2, vc3];
        _tabBarController.delegate = self;
    }
    
    return _tabBarController;
}

@end
