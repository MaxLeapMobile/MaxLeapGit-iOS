//
//  GMTimeLineCell.h
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMTimeLineCell : UITableViewCell

@property (nonatomic, copy) void(^tapUserAction)();
@property (nonatomic, copy) void(^tapSourceRepoAction)();

- (void)updateData:(id)data;
@end
