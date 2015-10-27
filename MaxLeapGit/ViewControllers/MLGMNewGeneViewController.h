//
//  GMAddNewGeneViewController.h
//  MaxLeapGit
//
//  Created by Julie on 15/10/8.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLGMNewGeneViewController : UIViewController
@property (nonatomic, strong) MLGMGene *gene;
@property (nonatomic, copy) void(^dismissBlock)(MLGMGene *newGene);
@end
