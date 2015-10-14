//
//  GMTimeLineCell.h
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGMEvent.h"

@interface MLGMTimeLineCell : UITableViewCell

@property (nonatomic, copy) void(^tapUserAction)(NSString *userName);
@property (nonatomic, copy) void(^tapSourceRepoAction)(NSString *repoName);
@property (nonatomic, copy) void(^tapForkRepoAction)(NSString *repoName);

- (void)configureCell:(MLGMEvent *)event;
@end