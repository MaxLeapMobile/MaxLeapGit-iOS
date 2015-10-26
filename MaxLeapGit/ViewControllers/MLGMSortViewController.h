//
//  MLGMSortViewController.h
//  MaxLeapGit
//
//  Created by Li Zhu on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLGMSortViewControllerDelegate <NSObject>

- (void)sortViewControllerDidSelectRowAtIndex:(NSUInteger)index;

@end

typedef enum : NSUInteger {
    MLGMSortGroupTypeRepo,
    MLGMSortGroupTypeUser,
} MLGMSortGroupType;

@interface MLGMSortViewController : UITableViewController
@property (nonatomic, weak) id<MLGMSortViewControllerDelegate> delegate;

- (instancetype)initWithGroupType:(MLGMSortGroupType)type selectedIndex:(NSUInteger)index;
@end
