//
//  UIViewController+Extension.m
//  MaxLeapGit
//
//  Created by Michael on 15/10/15.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)transparentNavigationBar:(BOOL)transparent {
    if (transparent) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x333333)] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.view.backgroundColor = UIColorFromRGB(0x333333);
        self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];;
        self.navigationController.navigationBar.translucent = NO;
    }
}

@end

