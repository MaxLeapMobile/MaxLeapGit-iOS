//
//  MLGMRecommendEmptyView.h
//  MaxLeapGit
//
//  Created by julie on 15/10/10.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMRecommendEmptyView : UIView
- (instancetype)initWithFrame:(CGRect)frame addNewGeneAction:(dispatch_block_t)addNewGeneAction replayAction:(dispatch_block_t)replayAction;
@end
