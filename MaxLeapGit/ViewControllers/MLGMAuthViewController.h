//
//  MLGMAuthViewController.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLGMAuthViewController;

@protocol MLGMAuthViewControllerDelegate <NSObject>
- (void)authViewController:(MLGMAuthViewController *)authViewController didReceiveAccessToken:(NSString *)accessToken;
@end

@interface MLGMAuthViewController : UIViewController
@property (nonatomic, weak) id<MLGMAuthViewControllerDelegate> delegate;
@end
