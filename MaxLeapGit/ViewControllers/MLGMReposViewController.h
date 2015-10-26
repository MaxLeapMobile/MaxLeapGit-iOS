//
//  MLGMReposController.h
//  MaxLeapGit
//
//  Created by Li Zhu on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MLGMReposControllerTypeNone,
    MLGMReposControllerTypeRepos,
    MLGMReposControllerTypeStars,
} MLGMReposControllerType;

@interface MLGMReposViewController : UIViewController
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, assign) MLGMReposControllerType type;
@end
