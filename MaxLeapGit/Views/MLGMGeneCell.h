//
//  MLGMGeneCell.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/19.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMGeneCell : UITableViewCell
@property (nonatomic, copy) void(^editingButtonEventHandler)(MLGMGene *gene);
@property (nonatomic, readonly, assign) NSUInteger index;

- (void)configureCell:(MLGMGene *)gene;
@end
