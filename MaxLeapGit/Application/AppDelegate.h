//
//  AppDelegate.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/9/22.
//  Copyright (c) 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLGMTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) MLGMTabBarController *tabBarController;

@end

