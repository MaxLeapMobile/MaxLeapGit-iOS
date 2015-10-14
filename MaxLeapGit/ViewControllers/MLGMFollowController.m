//
//  MLGMFollowersAndFollowingController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMFollowController.h"
#import "MLGMFollowUserCell.h"
#import "MLGMUserPageViewController.h"
#import "MLGMTabBarController.h"

@interface MLGMFollowController ()
@property (nonatomic, assign) MLGMFollowControllerType type;
@property (nonatomic, strong) NSArray *data;
@end

@implementation MLGMFollowController

- (instancetype)initWithType:(MLGMFollowControllerType)type {
    self = [super init];
    if (self) {
        _type = type;

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadData];
    [self configureUI];
}

- (void)loadData {
    _data = @[@"", @""];//temp
}

- (void)configureUI {
    if (_type == MLGMFollowControllerTypeFollowers) {
        self.title = NSLocalizedString(@"Followers", @"");
    } else if (_type == MLGMFollowControllerTypeFollowing) {
        self.title = NSLocalizedString(@"Following", @"");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MLGMFollowUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MLGMUserPageViewController *userPageVC = [[MLGMUserPageViewController alloc] init];
    userPageVC.userName = @"xdre";
    [self.navigationController pushViewController:userPageVC animated:YES];
}

@end
