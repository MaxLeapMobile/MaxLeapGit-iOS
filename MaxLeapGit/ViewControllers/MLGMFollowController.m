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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:ImageNamed(@"back_arrow_left_normal") forState:UIControlStateNormal];
    [backButton setImage:ImageNamed(@"back_arrow_left_selected") forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0, 0, 13 + 6 + 40, 22);
    [backButton setTitle:NSLocalizedString(@"Back", @"") forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -6)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:12/255.0 green:91/255.0 blue:254/255.0 alpha:1] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
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

#pragma mark - Actions
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGMFollowUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MLGMFollowUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.followAction = ^{
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MLGMUserPageViewController *userPageVC = [[MLGMUserPageViewController alloc] init];
    userPageVC.isMyPage = NO;
    [self.navigationController pushViewController:userPageVC animated:YES];
}

@end
