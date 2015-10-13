//
//  MLGMSortViewController.h
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLGMSortViewControllerDelegate <NSObject>

- (void)sortViewControllerDidSelectSortMethod:(NSString *)sortMethod;

@end

typedef enum : NSUInteger {
    MLGMSortGroupTypeRepo,
    MLGMSortGroupTypeUser,
} MLGMSortGroupType;

@interface MLGMSortViewController : UITableViewController
@property (nonatomic, weak) id<MLGMSortViewControllerDelegate> delegate;

- (instancetype)initWithSortGroupType:(MLGMSortGroupType)type selectedSortMethod:(NSString *)selectedMethod;

@end
