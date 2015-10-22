//
//  GMMyPageViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMHomePageViewController.h"

@interface MLGMHomePageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) BOOL isLoginUserHomePage;
@property (nonatomic, strong) MLGMActorProfile *userProfile;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSLayoutConstraint *bgViewTopConstraints;
@property (nonatomic, strong) NSLayoutConstraint *bgViewHeightConstraints;
@end

@implementation MLGMHomePageViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userProfile = [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:self.ownerName];
    self.view.backgroundColor = UIColorFromRGB(0xefeff4);
    [self configureSubViews];
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(MLGMCustomTabBarController *)self.navigationController.tabBarController setTabBarHidden:!self.isLoginUserHomePage];
    [self transparentNavigationBar:YES];
    
    [KSharedWebService userProfileForUserName:self.ownerName completion:^(MLGMActorProfile *userProfile, NSError *error) {
        [self.tableView reloadData];
        [KSharedWebService starCountForUserName:self.ownerName completion:^(NSUInteger starCount, NSString *userName, NSError *error) {
            [self.tableView reloadData];
        }];
        
        [KSharedWebService organizationCountForUserName:self.ownerName completion:^(NSUInteger orgCount, NSError *error) {
            [self.tableView reloadData];
        }];
    }];
    
    [self updateFollowState];
    [KSharedWebService isUserName:kOnlineUserName followTargetUserName:self.ownerName completion:^(BOOL isFollow, NSString *targetUserName, NSError *error) {
        [self updateFollowState];
    }];
}

#pragma mark- Override Parent Methods
- (void)updateViewConstraints {
    if (!_didSetupConstraints) {
        [self.bgView pinToSuperviewEdges: JRTViewPinRightEdge | JRTViewPinLeftEdge inset:0.0f];
        self.bgViewTopConstraints = [self.bgView pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeTop ofItem:self.view];
        self.bgViewHeightConstraints = [self.bgView constrainToHeight:190];
        
        [self.tableView pinToSuperviewEdges:JRTViewPinAllEdges inset:0];
        
        _didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark- SubViews Configuration
- (void)configureSubViews {
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.tableView];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectZero];
    if (self.isLoginUserHomePage) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithNormalImagenName:@"search_icon_normal"
                                                                                  selectedImageName:@"search_icon_selected"
                                                                                             target:self
                                                                                             action:@selector(searchButtonPressed:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(followButtonPressed:)];
    }
}

#pragma mark- Actions
- (void)followButtonPressed:(id)sender {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"sourceLoginName = %@ and targetLoginName = %@", kOnlineUserName, self.ownerName];
    MLGMFollowRelation *followRelation = [MLGMFollowRelation MR_findFirstWithPredicate:p];
    if (followRelation.isFollow.boolValue) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Unfollowing", @"")];
        [[MLGMWebService sharedInstance] unfollowTargetUserName:self.ownerName completion:^(BOOL isUnFollow, NSString *targetUserName, NSError *error) {
            [SVProgressHUD dismiss];
            [self updateFollowState];
        }];
    } else {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Following", @"")];
        [[MLGMWebService sharedInstance] followTargetUserName:self.ownerName completion:^(BOOL isUnFollow, NSString *targetUserName, NSError *error) {
            [SVProgressHUD dismiss];
            [self updateFollowState];
        }];
    }
}

- (void)searchButtonPressed:(id)sender {
    MLGMSearchViewController *vcSearch = [[MLGMSearchViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcSearch];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark- Public Methods

#pragma mark- Private Methods
- (void)updateFollowState {
    if (!self.isLoginUserHomePage) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"sourceLoginName = %@ and targetLoginName = %@", kOnlineUserName, self.ownerName];
        MLGMFollowRelation *followRelation = [MLGMFollowRelation MR_findFirstWithPredicate:p];
        if (!followRelation) {
            return;
        }
        
        if (followRelation.isFollow.boolValue) {
            [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Unfollow", nil)];
        } else {
            [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Follow", nil)];
        }
    }
}

#pragma mark- Delegate，DataSource, Callback Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat scrollOffset = scrollView.contentOffset.y;
        if (scrollOffset < 0) {
            self.bgViewHeightConstraints.constant = 190 - scrollOffset;
            self.bgViewTopConstraints.constant = 0;
        } else {
            self.bgViewHeightConstraints.constant = 190;
            self.bgViewTopConstraints.constant = -scrollOffset;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self isLoginUserHomePage]) {
        return 4;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isLoginUserHomePage]) {
        if (section == 0) {
            return 1;
        }
        
        if (section == 1) {
            return 1;
        }
        
        if (section == 2) {
            return 4;
        }
        
        if (section == 3) {
            return 1;
        }
    } else {
        if (section == 0) {
            return 1;
        }
        
        if (section == 1) {
            return 4;
        }
        
        if (section == 2) {
            return 1;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kHomePageHeaderReuseIdentifier = @"MLGMHomePageHeaderCell";
    static NSString *kHomePageReuseIdentifier = @"MLGMHomePageCell";
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kHomePageHeaderReuseIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kHomePageReuseIdentifier forIndexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self isLoginUserHomePage]) {
        if (indexPath.section == 0) {
            cell = [self configureHeaderCell:(MLGMHomePageHeaderCell *)cell];
        }
        
        if (indexPath.section == 1) {
            cell = [self configureGeneCell:(MLGMHomePageCell *)cell];
        }
        
        
        if (indexPath.section == 2) {
            cell = [self configureBaseInfoCell:(MLGMHomePageCell *)cell index:indexPath.row];
        }
        
        if (indexPath.section == 3) {
            cell = [self configureOrganizationCell:(MLGMHomePageCell *)cell];
        }
    } else {
        if (indexPath.section == 0) {
            cell = [self configureHeaderCell:(MLGMHomePageHeaderCell *)cell];
        }
        
        if (indexPath.section == 1) {
            cell = [self configureBaseInfoCell:(MLGMHomePageCell *)cell index:indexPath.row];
        }
        
        if (indexPath.section == 2) {
            cell = [self configureOrganizationCell:(MLGMHomePageCell *)cell];
        }
    }
    
    return cell;
}

- (MLGMHomePageHeaderCell *)configureHeaderCell:(MLGMHomePageHeaderCell *)userProfileCell {
    __weak typeof(self) weakSelf = self;
    
    userProfileCell.followersButtonAction = ^{
        MLGMFollowViewController *followerVC = [MLGMFollowViewController new];
        followerVC.type = MLGMFollowControllerTypeFollowers;
        followerVC.ownerName = self.userProfile.loginName;
        [weakSelf.navigationController pushViewController:followerVC animated:YES];
    };
    
    userProfileCell.followingButtonAction = ^{
        MLGMFollowViewController *followingerVC = [MLGMFollowViewController new];
        followingerVC.type = MLGMFollowControllerTypeFollowing;
        followingerVC.ownerName = self.userProfile.loginName;
        [weakSelf.navigationController pushViewController:followingerVC animated:YES];
    };
    
    userProfileCell.reposButtonAction = ^{
        MLGMReposViewController *reposVC = [MLGMReposViewController new];
        reposVC.ownerName = self.ownerName;
        reposVC.type = MLGMReposControllerTypeRepos;
        [weakSelf.navigationController pushViewController:reposVC animated:YES];
    };
    
    userProfileCell.starsButtonAction = ^{
        MLGMReposViewController *starVC = [MLGMReposViewController new];
        starVC.ownerName = self.ownerName;
        starVC.type = MLGMReposControllerTypeStars;
        [weakSelf.navigationController pushViewController:starVC animated:YES];
    };
    
    [userProfileCell configureView:self.userProfile];
    
    return userProfileCell;
}

- (MLGMHomePageCell *)configureGeneCell:(MLGMHomePageCell *)geneCell {
    geneCell.textLabel.text = NSLocalizedString(@"Genes", nil);
    if  (self.userProfile.genes) {
        geneCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)[kOnlineAccountProfile.genes count]];
    } else {
        geneCell.detailTextLabel.text = @"-";
    }
    
    geneCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return geneCell;
}

- (MLGMHomePageCell *)configureBaseInfoCell:(MLGMHomePageCell *)baseInfoCell index:(NSInteger)index {
    if (index == 0) {
        baseInfoCell.textLabel.text = NSLocalizedString(@"Location", nil);
        if (self.userProfile.location) {
            baseInfoCell.detailTextLabel.text = self.userProfile.location;
        } else {
            baseInfoCell.detailTextLabel.text = @"-";
        }
        
        [baseInfoCell addBottomBorderWithColor:UIColorFromRGB(0xefeff4) width:1];
    }
    
    if (index == 1) {
        baseInfoCell.textLabel.text = NSLocalizedString(@"Email",nil);
        if (self.userProfile.email) {
            baseInfoCell.detailTextLabel.text = self.userProfile.email;
        } else {
            baseInfoCell.detailTextLabel.text = @"-";
        }
        
        [baseInfoCell addBottomBorderWithColor:UIColorFromRGB(0xefeff4) width:1];
        return baseInfoCell;
    }
    
    if (index == 2) {
        baseInfoCell.textLabel.text = NSLocalizedString(@"Company", nil);
        if (self.userProfile.company) {
            baseInfoCell.detailTextLabel.text = self.userProfile.company;
        } else {
            baseInfoCell.detailTextLabel.text = @"-";
        }
        
        [baseInfoCell addBottomBorderWithColor:UIColorFromRGB(0xefeff4) width:1];
    }
    
    if (index == 3) {
        baseInfoCell.textLabel.text = NSLocalizedString(@"Joined in", nil);
        if (self.userProfile.githubCreatTime) {
            NSString *humanDateString = [self.userProfile.githubCreatTime humanDateString];
            baseInfoCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", humanDateString];
        } else {
            baseInfoCell.detailTextLabel.text = @"-";
        }
    }
    
    return baseInfoCell;
}

- (MLGMHomePageCell *)configureOrganizationCell:(MLGMHomePageCell *)organizationCell {
    organizationCell.textLabel.text = NSLocalizedString(@"Organization", nil);
    if (self.userProfile.organizationCount) {
        organizationCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.userProfile.organizationCount];
        if (self.userProfile.organizationCount.integerValue > 0) {
            organizationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            organizationCell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        organizationCell.detailTextLabel.text = @"-";
        organizationCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return organizationCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isLoginUserHomePage]) {
        if (indexPath.section == 1) {
            MLGMGenesViewController *genesVC = [[MLGMGenesViewController alloc] init];
            [self.navigationController pushViewController:genesVC animated:YES];
        } else if (indexPath.section == 3 && [self.userProfile.organizationCount integerValue] > 0) {
            UIViewController *orgnizationVC = [[MLGMOrganizationsViewController alloc] init];
            [self.navigationController pushViewController:orgnizationVC animated:YES];
        }
    } else {
        if (indexPath.section == 2 && [self.userProfile.organizationCount integerValue] > 0) {
            MLGMOrganizationsViewController *orgnizationVC = [[MLGMOrganizationsViewController alloc] init];
            orgnizationVC.ownerName = self.ownerName;
            [self.navigationController pushViewController:orgnizationVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 196;
    } else {
        return 44;
    }
}

#pragma mark- Getter Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[MLGMHomePageHeaderCell class] forCellReuseIdentifier:@"MLGMHomePageHeaderCell"];
        [_tableView registerClass:[MLGMHomePageCell class] forCellReuseIdentifier:@"MLGMHomePageCell"];
        
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIEdgeInsets adjustForTabbarInsets = (UIEdgeInsets){0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0};
        _tableView.contentInset = adjustForTabbarInsets;
        _tableView.scrollIndicatorInsets = adjustForTabbarInsets;
        _tableView.tableHeaderView = self.headerView;
        _tableView.sectionHeaderHeight = 7;
        _tableView.sectionFooterHeight = 7;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 0.5)];
    }
    
    return _headerView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView autoLayoutView];
        _bgView.backgroundColor = ThemeNavigationBarColor;
    }
    
    return _bgView;
}

- (MLGMActorProfile *)userProfile {
    return [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:self.ownerName];
}

#pragma mark- Helper Method
- (BOOL)isLoginUserHomePage {
    return [kOnlineUserName isEqualToString:self.ownerName];
}

#pragma mark Temporary Area

@end
