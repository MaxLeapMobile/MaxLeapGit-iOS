//
//  GMTimeLineViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMTimeLineViewController.h"
#import "MLGMTimeLineCell.h"
#import "MLGMSearchViewController.h"
#import "MLGMNavigationController.h"
#import "MLGMRepoDetailController.h"
#import "MLGMTabBarController.h"
#import "MLGMUserPageViewController.h"

@interface MLGMTimeLineViewController () 
@end

@implementation MLGMTimeLineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:ImageNamed(@"search_icon_normal") forState:UIControlStateNormal];
    [searchButton setImage:ImageNamed(@"search_icon_selected") forState:UIControlStateHighlighted];
    searchButton.frame = CGRectMake(0, 0, 18, 18);
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

- (void)search {
    MLGMSearchViewController *vcSearch = [[MLGMSearchViewController alloc] init];
    UINavigationController *nav = [[MLGMNavigationController alloc] initWithRootViewController:vcSearch];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGMTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MLGMTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
   
    cell.tapUserAction = ^{
        MLGMUserPageViewController *vcUser = [[MLGMUserPageViewController alloc] init];
        vcUser.isMyPage = NO;
        [self.navigationController pushViewController:vcUser animated:YES];
    };
    cell.tapSourceRepoAction = ^{
        MLGMRepoDetailController *vc = [[MLGMRepoDetailController alloc] init];
        vc.url = @"https://github.com/eyeplum/Conche"; //temp
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

@end
