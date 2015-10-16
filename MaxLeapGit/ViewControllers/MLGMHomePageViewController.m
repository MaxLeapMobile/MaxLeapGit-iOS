//
//  GMMyPageViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMHomePageViewController.h"
#import "MLGMSearchViewController.h"
#import "MLGMHomePageHeaderCell.h"
#import "MLGMHomePageCell.h"
#import "MLGMGenesViewController.h"
#import "MLGMFollowViewController.h"
#import "MLGMReposViewController.h"
#import "MLGMOrganizationsViewController.h"
#import "MLGMTabBarController.h"
#import "UIView+CustomBorder.h"
#import "NSDate+Extension.h"
#import "UIBarButtonItem+Extension.h"

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
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:!self.isLoginUserHomePage];
    [self transparentNavigationBar:YES];
    
    [[MLGMWebService sharedInstance] userProfileForUserName:self.ownerName completion:^(MLGMActorProfile *userProfile, NSError *error) {
        [self.tableView reloadData];
        [[MLGMWebService sharedInstance] starCountForUserName:self.ownerName completion:^(NSUInteger starCount, NSString *userName, NSError *error) {
            [self.tableView reloadData];
        }];
    }];
    
    [self updateFollowState];
    [[MLGMWebService sharedInstance] isUserName:kOnlineUserName followTargetUserName:self.ownerName completion:^(BOOL isFollow, NSString *targetUserName, NSError *error) {
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

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
        [[MLGMWebService sharedInstance] unfollowTargetUserName:self.ownerName completion:^(BOOL isUnFollow, NSString *targetUserName, NSError *error) {
            [self updateFollowState];
        }];
    } else {
        [[MLGMWebService sharedInstance] followTargetUserName:self.ownerName completion:^(BOOL isUnFollow, NSString *targetUserName, NSError *error) {
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    
    if (indexPath.section == 0) {
        MLGMHomePageHeaderCell *userProfileCell = (MLGMHomePageHeaderCell *)cell;
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
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"Genes";
        if  (self.userProfile.genes) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)[self.userProfile.genes count]];
        } else {
            cell.detailTextLabel.text = @"-";
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Location";
            if (self.userProfile.location) {
                cell.detailTextLabel.text = self.userProfile.location;
            } else {
                cell.detailTextLabel.text = @"-";
            }
            
            [cell addBottomBorderWithColor:UIColorFromRGB(0xefeff4) width:1];
            return cell;
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Email";
            if (self.userProfile.email) {
                cell.detailTextLabel.text = self.userProfile.email;
            } else {
                cell.detailTextLabel.text = @"-";
            }
            
            [cell addBottomBorderWithColor:UIColorFromRGB(0xefeff4) width:1];
            return cell;
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Company";
            if (self.userProfile.company) {
                cell.detailTextLabel.text = self.userProfile.company;
            } else {
                cell.detailTextLabel.text = @"-";
            }
            
            [cell addBottomBorderWithColor:UIColorFromRGB(0xefeff4) width:1];
            return cell;
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"Joined in";
            if (self.userProfile.githubCreatedAt) {
                NSString *humanDateString = [self.userProfile.githubCreatedAt humanDateString];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", humanDateString];
            } else {
                cell.detailTextLabel.text = @"-";
            }
            
            return cell;
        }
        
        return cell;
    }
    
    if (indexPath.section == 3) {
        cell.textLabel.text = @"Organization";
        if (self.userProfile.organizations) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.userProfile.organizations];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.detailTextLabel.text = @"-";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        MLGMGenesViewController *vcGenes = [[MLGMGenesViewController alloc] init];
        [self.navigationController pushViewController:vcGenes animated:YES];
    } else if (indexPath.section == 3 && [self.userProfile.organizations integerValue] > 0) {
        UIViewController *vcOrganization = [[MLGMOrganizationsViewController alloc] init];
        [self.navigationController pushViewController:vcOrganization animated:YES];
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
