//
//  MLGMFollowersAndFollowingController.h
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MLGMFollowControllerTypeNone,
    MLGMFollowControllerTypeFollowers,
    MLGMFollowControllerTypeFollowing,
} MLGMFollowControllerType;

//followers; following
@interface MLGMFollowController : UITableViewController
- (instancetype)initWithType:(MLGMFollowControllerType)type;
@end
