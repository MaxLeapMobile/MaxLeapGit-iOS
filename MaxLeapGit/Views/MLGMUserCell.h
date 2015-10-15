//
//  GMUserCell.h
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLGMActorProfile;
@interface MLGMUserCell : UITableViewCell
- (void)updateData:(MLGMActorProfile *)actorProfile;
@end
