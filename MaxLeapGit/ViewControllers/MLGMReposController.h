//
//  MLGMReposController.h
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MLGMReposControllerTypeNone,
    MLGMReposControllerTypeRepos,
    MLGMReposControllerTypeStars,
} MLGMReposControllerType;

@interface MLGMReposController : UITableViewController
- (instancetype)initWithType:(MLGMReposControllerType)type;
@end
