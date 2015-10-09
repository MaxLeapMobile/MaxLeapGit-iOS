//
//  GMTimeLineViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "GMTimeLineViewController.h"
#import "GMTimeLineCell.h"
#import "GMSearchViewController.h"
#import "GMNavigationController.h"

@interface GMTimeLineViewController ()

@end

@implementation GMTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
}

- (void)search {
    GMSearchViewController *vcSearch = [[GMSearchViewController alloc] init];
    UINavigationController *nav = [[GMNavigationController alloc] initWithRootViewController:vcSearch];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[GMTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

@end
