//
//  MLGMOrganizationsController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMOrganizationsController.h"
#import "MLGMUserCell.h"
#import "MLGMTabBarController.h"
#import "MLGMWebViewController.h"

@interface MLGMOrganizationsController ()

@end

@implementation MLGMOrganizationsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.title = NSLocalizedString(@"Organization", @"");
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MLGMUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MLGMWebViewController *vc = [[MLGMWebViewController alloc] init];
    vc.url = @"https://github.com/dailymotion";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
