//
//  GMMyPageViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMMyPageViewController.h"
#import "MLGMSearchViewController.h"
#import "MLGMUserDetailView.h"
#import "MLGMGenesViewController.h"
#import "MLGMNavigationController.h"

@interface MLGMMyPageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MLGMMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configureUI];
}

- (void)configureUI {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *headerView = [[MLGMUserDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.tableView.tableHeaderView = headerView;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.frame = CGRectMake(self.view.bounds.size.width - 70, 20, 60, 40);
    [searchButton setTitle:NSLocalizedString(@"Search", @"") forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchButton];
}

#pragma mark - Actions
- (void)search {
    MLGMSearchViewController *vcSearch = [[MLGMSearchViewController alloc] init];
    UINavigationController *nav = [[MLGMNavigationController alloc] initWithRootViewController:vcSearch];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Genes";
        cell.detailTextLabel.text = @"2";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = @"****";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = @"****";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Company";
            cell.detailTextLabel.text = @"****";
        } else {
            cell.textLabel.text = @"Joined in";
            cell.detailTextLabel.text = @"****";
        }
        
    } else {
        cell.textLabel.text = @"Organization";
        cell.detailTextLabel.text = @"MaxLeapMobile";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIViewController *vcGenes = [[MLGMGenesViewController alloc] init];
        UINavigationController *nav = [[MLGMNavigationController alloc] initWithRootViewController:vcGenes];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
