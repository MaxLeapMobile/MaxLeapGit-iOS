//
//  MLGMTabBarController.h
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMTabBarController : UITabBarController
@property (nonatomic, copy) dispatch_block_t centralButtonAction;

- (void)setTabBarHidden:(BOOL)hidden;

@end