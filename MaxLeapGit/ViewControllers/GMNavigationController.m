//
//  GMNavigationController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "GMNavigationController.h"

@interface GMNavigationController ()

@end

@implementation GMNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.barTintColor = ThemeNavigationBarColor;
        self.navigationBar.translucent = NO;
    }
    return self;
}

@end
