//
//  MLGMSearchPageTitleView.h
//  MaxLeapGit
//
//  Created by Li Zhu on 15/10/14.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMSearchPageTitleView : UIView
@property (nonatomic, copy) dispatch_block_t repoButtonAction;
@property (nonatomic, copy) dispatch_block_t userButtonAction;
@property (nonatomic, copy) dispatch_block_t sortOrderAction;
@end
