//
//  GMRecommendViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMRecommendViewController.h"
#import "MLGMSearchViewController.h"
#import "MLGMGenesViewController.h"
#import "MLGMNavigationController.h"

@interface MLGMRecommendViewController ()

@end

@implementation MLGMRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Gene", @"") style:UIBarButtonItemStyleDone target:self action:@selector(showGitHubGenes)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
}

- (void)search {
    MLGMSearchViewController *vcSearch = [[MLGMSearchViewController alloc] init];
    UINavigationController *nav = [[MLGMNavigationController alloc] initWithRootViewController:vcSearch];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showGitHubGenes {
    MLGMGenesViewController *vcGenes = [[MLGMGenesViewController alloc] init];
    [self.navigationController pushViewController:vcGenes animated:YES];
}

@end
