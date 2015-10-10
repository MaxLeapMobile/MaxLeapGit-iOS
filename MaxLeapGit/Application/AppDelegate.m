//
//  AppDelegate.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/9/22.
//  Copyright (c) 2015年 iLegendsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "MLGMTimeLineViewController.h"
#import "MLGMRecommendViewController.h"
#import "MLGMMyPageViewController.h"
#import "MLGMIntroductionViewController.h"
#import "MLGMNavigationController.h"

@interface AppDelegate () <UITabBarControllerDelegate>
@property (nonatomic, assign) NSUInteger selectedControllerIndex;
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
    [Flurry startSession:CONFIGURE(@"3cce3f30d1c88bef1cb54f4caa09abeb64863112")];
}

- (void)mainViewInit {
    [self setUpTabBarController];
    
    BOOL isAuthorized = YES;//TODO:check authorization state
    if (!isAuthorized) {
        UIViewController *vcIntro = [[MLGMIntroductionViewController alloc] init];
        self.window.rootViewController = vcIntro;
    } else {
        self.window.rootViewController = self.tabBarController;
    }
}

- (void)setUpTabBarController {
    self.tabBarController = [[UITabBarController alloc] init];
    
    UIViewController *vc1 = [[MLGMTimeLineViewController alloc] init];
    UINavigationController *nav1 = [[MLGMNavigationController alloc] initWithRootViewController:vc1];
    nav1.title = vc1.title = NSLocalizedString(@"TimeLine", @"");
   
    UIViewController *vc2 = [[MLGMTimeLineViewController alloc] init];
    UINavigationController *nav2 = [[MLGMNavigationController alloc] initWithRootViewController:vc2];
    vc2.title = NSLocalizedString(@"TimeLine", @"");
    nav2.title = NSLocalizedString(@"Recommend", @"");
    
    UIViewController *vc3 = [[MLGMMyPageViewController alloc] init];
    UINavigationController *nav3 = [[MLGMNavigationController alloc] initWithRootViewController:vc3];
    nav3.title = vc3.title = NSLocalizedString(@"Mine", @"");
    
    self.tabBarController.viewControllers = @[nav1, nav2, nav3];
    self.tabBarController.delegate = self;
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
    }
    return YES;
}

@end
