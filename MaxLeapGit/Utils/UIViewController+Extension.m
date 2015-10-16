//
//  UIViewController+Extension.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/15.
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
        self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];;
        self.navigationController.navigationBar.translucent = NO;
    }
}

@end

//
////
////  UIViewController+Extension.m
////  MaxLeapGit
////
////  Created by Jun Xia on 15/10/15.
////  Copyright © 2015年 MaxLeapMobile. All rights reserved.
////
//
//#import "UIViewController+Extension.h"
//
//@implementation UIViewController (Extension)
//
//- (void)transparentNavigationBar:(BOOL)transparent {
//    if (transparent) {
//        UIImage *backgroundImage = [UIImage imageWithColor:[UIColor clearColor] withSize:CGSizeMake(self.navigationController.view.frame.size.width, 64)];
//        UIImage *shadowImage = [UIImage imageWithColor:[UIColor clearColor] withSize:CGSizeMake(self.navigationController.view.frame.size.width, 1)];
//        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.shadowImage = shadowImage;
//        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//        self.navigationController.navigationBar.translucent = YES;
//    } else {
//        UIImage *backgroundImage = [UIImage imageWithColor:UIColorFromRGB(0x333333) withSize:CGSizeMake(self.navigationController.view.frame.size.width, 64)];
//        UIImage *shadowImage = [UIImage imageWithColor:[UIColor clearColor] withSize:CGSizeMake(self.navigationController.view.frame.size.width, 1)];
//        
//        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.shadowImage = shadowImage;
//        self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0x333333);
//        self.navigationController.navigationBar.translucent = NO;
//    }
//}
//
//@end
