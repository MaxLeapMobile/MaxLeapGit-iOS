//
//  MLGMTabBarController.h
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMCustomTabBarController : UITabBarController
@property (nonatomic, copy) dispatch_block_t centralButtonAction;

- (void)setTabBarHidden:(BOOL)hidden;

@end
