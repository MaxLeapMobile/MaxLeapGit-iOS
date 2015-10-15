//
//  GMUserCell.h
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMFollowCell : UITableViewCell
@property (nonatomic, assign, readonly) BOOL isAnimationRunning;
@property (nonatomic, copy) void(^followButtonPressedAction)(NSString *targetLoginName);

- (void)configureCell:(MLGMActorProfile *)actorProfile;
- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;
@end
