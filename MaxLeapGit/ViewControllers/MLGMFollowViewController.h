//
//  MLGMFollowersAndFollowingController.h
//  MaxLeapGit
//
//  Created by Julie on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MLGMFollowControllerTypeNone,
    MLGMFollowControllerTypeFollowers,
    MLGMFollowControllerTypeFollowing,
} MLGMFollowControllerType;

@interface MLGMFollowViewController : UIViewController
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, assign) MLGMFollowControllerType type;
@end
