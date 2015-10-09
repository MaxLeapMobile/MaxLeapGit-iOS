//
//  GMRecommendViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "GMRecommendViewController.h"
#import "GMSearchViewController.h"
#import "GMGenesViewController.h"

@interface GMRecommendViewController ()

@end

@implementation GMRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Gene", @"") style:UIBarButtonItemStyleDone target:self action:@selector(showGitHubGenes)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
}

- (void)search {
    GMSearchViewController *vcSearch = [[GMSearchViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcSearch];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showGitHubGenes {
    GMGenesViewController *vcGenes = [[GMGenesViewController alloc] init];
    [self.navigationController pushViewController:vcGenes animated:YES];
}

@end
