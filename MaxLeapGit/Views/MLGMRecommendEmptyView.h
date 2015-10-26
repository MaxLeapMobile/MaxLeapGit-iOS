//
//  MLGMRecommendEmptyView.h
//  MaxLeapGit
//
//  Created by Julie on 15/10/10.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMRecommendEmptyView : UIView
- (instancetype)initWithFrame:(CGRect)frame addNewGeneAction:(dispatch_block_t)addNewGeneAction replayAction:(dispatch_block_t)replayAction;
@end
