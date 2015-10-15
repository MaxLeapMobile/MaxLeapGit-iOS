//
//  MLGMFollowersAndFollowingController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMFollowViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "MLGMFollowCell.h"
#import "MLGMHomePageViewController.h"
#import "MLGMTabBarController.h"
#import "MLGMWebService.h"

@interface MLGMFollowViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *backButtomItem;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MLGMFollowViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
    
    [self configureSubViews];
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView triggerPullToRefresh];
}

#pragma mark- Override Parent Methods
- (void)updateViewConstraints {
    if (!_didSetupConstraints) {
        [self.tableView pinToSuperviewEdges:JRTViewPinAllEdges inset:0.0f];
        
        _didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark- SubViews Configuration
- (void)configureSubViews {
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = self.backButtomItem;
    
    if (_type == MLGMFollowControllerTypeFollowers) {
        self.title = NSLocalizedString(@"Followers", @"");
    }
    
    if (_type == MLGMFollowControllerTypeFollowing) {
        self.title = NSLocalizedString(@"Following", @"");
    }
}

#pragma mark- Actions
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Public Methods

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak MLGMFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLGMFollowCell"];
    
    __weak typeof(self) weakSelf = self;
    
    cell.followButtonPressedAction = ^(NSString *targetLoginName){
        if (cell.isAnimationRunning) {
            return;
        }
        
        [cell startLoadingAnimation];
        
        NSPredicate *p = [NSPredicate predicateWithFormat:@"sourceLoginName = %@ and targetLoginName = %@", kOnlineUserName, targetLoginName];
        MLGMFollowRelation *followRelation = [MLGMFollowRelation MR_findFirstWithPredicate:p];
        if (followRelation.isFollow.boolValue) {
            [[MLGMWebService sharedInstance] unfollowTargetUserName:targetLoginName completion:^(BOOL isUnFollow, NSString *targetUserName, NSError *error) {
                [cell stopLoadingAnimation];
                [weakSelf.tableView reloadData];
            }];
        } else {
            [[MLGMWebService sharedInstance] followTargetUserName:targetLoginName completion:^(BOOL isUnFollow, NSString *targetUserName, NSError *error) {
                [cell stopLoadingAnimation];                
                [weakSelf.tableView reloadData];
            }];
        }
    };
    
    [cell configureCell:self.results[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLGMHomePageViewController *userPageVC = [[MLGMHomePageViewController alloc] init];
    userPageVC.ownerName = @"xdre";
    [self.navigationController pushViewController:userPageVC animated:YES];
}

#pragma mark- Getter Setter
- (UIBarButtonItem *)backButtomItem {
    if (!_backButtomItem) {
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
        _backButtomItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    return _backButtomItem;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView autoLayoutView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[MLGMFollowCell class] forCellReuseIdentifier:@"MLGMFollowCell"];
        
        __weak typeof(self) weakSelf = self;
        __block int page = 1;
        [self.tableView addPullToRefreshWithActionHandler:^{
            weakSelf.tableView.showsInfiniteScrolling = NO;
            page = 1;
            if (self.type == MLGMFollowControllerTypeFollowers) {
                [[MLGMWebService sharedInstance] followerListForUserName:weakSelf.ownerName fromPage:page completion:^(NSArray *userProfiles, BOOL isRechEnd, NSError *error) {
                    execute_after_main_queue(0.2, ^{
                        [weakSelf.tableView.pullToRefreshView stopAnimating];
                    });
                    weakSelf.tableView.showsInfiniteScrolling = !isRechEnd;
                    
                    if (!error) {
                        [weakSelf.results removeAllObjects];
                        [weakSelf.results addObjectsFromArray:userProfiles];
                        [weakSelf.tableView reloadData];
                    } else {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                    }
                }];
            }
            
            if (self.type == MLGMFollowControllerTypeFollowing) {
                [[MLGMWebService sharedInstance] followingListForUserName:weakSelf.ownerName fromPage:page completion:^(NSArray *userProfiles, BOOL isRechEnd, NSError *error) {
                    execute_after_main_queue(0.2, ^{
                        [weakSelf.tableView.pullToRefreshView stopAnimating];
                    });
                    weakSelf.tableView.showsInfiniteScrolling = !isRechEnd;
                    
                    if (!error) {
                        [weakSelf.results removeAllObjects];
                        [weakSelf.results addObjectsFromArray:userProfiles];
                        [weakSelf.tableView reloadData];
                    } else {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                    }
                }];
            }
            
        }];
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            if (self.type == MLGMFollowControllerTypeFollowers) {
                [[MLGMWebService sharedInstance] followerListForUserName:weakSelf.ownerName fromPage:page + 1 completion:^(NSArray *userProfiles, BOOL isRechEnd, NSError *error) {
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                    weakSelf.tableView.showsInfiniteScrolling = !isRechEnd;
                    if (!error) {
                        page++;
                        [weakSelf.results addObjectsFromArray:userProfiles];
                        [weakSelf.tableView reloadData];
                    } else {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                    }
                }];
            }
            
            if (self.type == MLGMFollowControllerTypeFollowing) {
                [[MLGMWebService sharedInstance] followingListForUserName:weakSelf.ownerName fromPage:page + 1 completion:^(NSArray *userProfiles, BOOL isRechEnd, NSError *error) {
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                    weakSelf.tableView.showsInfiniteScrolling = !isRechEnd;
                    if (!error) {
                        page++;
                        [weakSelf.results addObjectsFromArray:userProfiles];
                        [weakSelf.tableView reloadData];
                    } else {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                    }
                }];
            }
        }];
    }
    
    return _tableView;
}

- (NSMutableArray *)results {
    if (!_results) {
        _results = [NSMutableArray new];
    }
    
    return _results;
}

#pragma mark- Helper Method

#pragma mark Temporary Area

@end

