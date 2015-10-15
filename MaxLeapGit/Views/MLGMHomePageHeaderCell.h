//
//  MLGMUserDetailView.h
//  MaxLeapGit
//
//  Created by julie on 15/10/10.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMHomePageHeaderCell : UITableViewCell
@property (nonatomic, copy) dispatch_block_t followersButtonAction;
@property (nonatomic, copy) dispatch_block_t followingButtonAction;
@property (nonatomic, copy) dispatch_block_t reposButtonAction;
@property (nonatomic, copy) dispatch_block_t starsButtonAction;

- (void)configureView:(MLGMActorProfile *)actorProfile;
@end