//
//  GMMyPageViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMUserPageViewController.h"
#import "MLGMSearchViewController.h"
#import "MLGMUserDetailView.h"
#import "MLGMGenesViewController.h"
#import "MLGMNavigationController.h"
#import "MLGMFollowController.h"
#import "MLGMReposController.h"
#import "MLGMOrganizationsController.h"
#import "MLGMTabBarController.h"

@interface MLGMUserPageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MLGMUserPageViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isMyPage = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:_isMyPage ? NO : YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureUI];
}

- (void)configureUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height - 180) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    MLGMUserDetailView *headerView = [[MLGMUserDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    [self.view addSubview:headerView];
    
    __weak typeof(self) wSelf = self;
    headerView.followersButtonAction = ^{
        [wSelf presentFollowerControllersWithType:MLGMFollowControllerTypeFollowers];
    };
    headerView.followingButtonAction = ^{
        [wSelf presentFollowerControllersWithType:MLGMFollowControllerTypeFollowing];
    };
    headerView.reposButtonAction = ^{
        [wSelf presentReposControllerWithType:MLGMReposControllerTypeRepos];
    };
    headerView.starsButtonAction = ^{
        [wSelf presentReposControllerWithType:MLGMReposControllerTypeStars];
    };
   
    [self configureTopButtons];
}

- (void)configureTopButtons {
    if (_isMyPage) {
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchButton setImage:ImageNamed(@"search_icon_normal") forState:UIControlStateNormal];
        [searchButton setImage:ImageNamed(@"search_icon_selected") forState:UIControlStateHighlighted];
        searchButton.frame = CGRectMake(self.view.bounds.size.width - 27, 34, 18, 18);
        [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:searchButton];
    } else {
        UIButton *followButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [followButton setTitle:NSLocalizedString(@"Unfollow", @"") forState:UIControlStateNormal];
        followButton.frame = CGRectMake(self.view.bounds.size.width - 100, 33, 92, 20);
        followButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:followButton];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:ImageNamed(@"back_arrow_left_normal") forState:UIControlStateNormal];
        [backButton setImage:ImageNamed(@"back_arrow_left_selected") forState:UIControlStateHighlighted];
        backButton.frame = CGRectMake(8.5, 32.5, 13 + 6 + 40, 22);
        [backButton setTitle:NSLocalizedString(@"Back", @"") forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -6)];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor colorWithRed:12/255.0 green:91/255.0 blue:254/255.0 alpha:1] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
    }
}

- (void)presentFollowerControllersWithType:(MLGMFollowControllerType)type {
    MLGMFollowController *followVC = [[MLGMFollowController alloc] initWithType:type];
    [self.navigationController pushViewController:followVC animated:YES];
}

- (void)presentReposControllerWithType:(MLGMReposControllerType)type {
    MLGMReposController *reposVC = [[MLGMReposController alloc] initWithType:type];
    [self.navigationController pushViewController:reposVC animated:YES];
}

#pragma mark - Actions
- (void)search {
    MLGMSearchViewController *vcSearch = [[MLGMSearchViewController alloc] init];
    UINavigationController *nav = [[MLGMNavigationController alloc] initWithRootViewController:vcSearch];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)followOrUnfollow {
   
    
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
        cell.detailTextLabel.text = @"1";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        MLGMGenesViewController *vcGenes = [[MLGMGenesViewController alloc] init];
        [self.navigationController pushViewController:vcGenes animated:YES];
    } else if (indexPath.section == 2) {
        UIViewController *vcOrganization = [[MLGMOrganizationsController alloc] init];
        [self.navigationController pushViewController:vcOrganization animated:YES];
    }
}

@end
