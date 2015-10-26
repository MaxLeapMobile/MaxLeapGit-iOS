//
//  GMAddNewGeneViewController.h
//  MaxLeapGit
//
//  Created by Li Zhu on 15/10/8.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMNewGeneViewController : UIViewController
@property (nonatomic, strong) MLGMGene *gene;
@property (nonatomic, copy) dispatch_block_t dismissBlock;
@end
