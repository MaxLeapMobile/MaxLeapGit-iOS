//
//  AppDelegate.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/9/22.
//  Copyright (c) 2015年 iLegendsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "GMTimeLineViewController.h"
#import "GMRecommendViewController.h"
#import "GMMyPageViewController.h"
#import "GMIntroductionViewController.h"
#import "GMNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureThirdPartySDK];
   
    [self mainViewInit];
    
    return YES;    // Override point for customization after application launch.
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

- (void)configureThirdPartySDK {
    [Flurry setAppVersion:kAppVersion];
    [Flurry startSession:CONFIGURE(@"GitHub_Client_Secret")];
}

- (void)mainViewInit {
    [self setUpTabBarController];
    
    BOOL isAuthorized = YES;//TODO:check authorization state
    if (!isAuthorized) {
        UIViewController *vcIntro = [[GMIntroductionViewController alloc] init];
        self.window.rootViewController = vcIntro;
    } else {
        self.window.rootViewController = self.tabBarController;
    }
}

- (void)setUpTabBarController {
    self.tabBarController = [[UITabBarController alloc] init];
    
    UIViewController *vc1 = [[GMTimeLineViewController alloc] init];
    UINavigationController *nav1 = [[GMNavigationController alloc] initWithRootViewController:vc1];
    nav1.title = vc1.title = NSLocalizedString(@"TimeLine", @"");
   
    UIViewController *vc2 = [[GMRecommendViewController alloc] init];
    UINavigationController *nav2 = [[GMNavigationController alloc] initWithRootViewController:vc2];
    nav2.title = vc2.title = NSLocalizedString(@"Recommend", @"");
    
    UIViewController *vc3 = [[GMMyPageViewController alloc] init];
    UINavigationController *nav3 = [[GMNavigationController alloc] initWithRootViewController:vc3];
    nav3.title = vc3.title = NSLocalizedString(@"Mine", @"");
    
    self.tabBarController.viewControllers = @[nav1, nav2, nav3];
}

@end
