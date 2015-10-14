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
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface MLGMTimeLineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, assign) BOOL didInitLoaded;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MLGMTimeLineViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureTableView];
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (kOnlineAccount && !_didInitLoaded) {
        [self.tableView triggerPullToRefresh];
        _didInitLoaded = YES;
    }
}

#pragma mark- SubViews Configuration
- (void)configureNavigationBar {
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}

- (void)configureTableView {
    [self.tableView registerClass:[MLGMTimeLineCell class] forCellReuseIdentifier:@"Cell"];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];

    __weak typeof(self) weakSelf = self;
    __block int page = 1;
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.tableView.showsInfiniteScrolling = NO;
        page = 1;
        [[MLGMWebService sharedInstance] timeLineForUserName:kOnlineAccount.actorProfile.loginName
                                                    fromPage:page
                                                  completion:^(NSArray *events, BOOL isRechEnd, NSError *error) {
                                                      execute_after_main_queue(0.2, ^{
                                                          [weakSelf.tableView.pullToRefreshView stopAnimating];
                                                      });
                                                      weakSelf.tableView.showsInfiniteScrolling = !isRechEnd;
                                                      
                                                      if (!error) {
                                                          [weakSelf.results removeAllObjects];
                                                          [weakSelf.results addObjectsFromArray:events];
                                                          [weakSelf.tableView reloadData];
                                                      } else {
                                                          [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                                                      }
                                                  }];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [[MLGMWebService sharedInstance] timeLineForUserName:kOnlineAccount.actorProfile.loginName
                                                    fromPage:page + 1
                                                  completion:^(NSArray *events, BOOL isRechEnd, NSError *error) {
                                                      [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                                      weakSelf.tableView.showsInfiniteScrolling = !isRechEnd;
                                                      if (!error) {
                                                          page++;
                                                          [weakSelf.results addObjectsFromArray:events];
                                                          [weakSelf.tableView reloadData];
                                                      } else {
                                                          [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                                                      }
                                                  }];
    }];

    [self.view addSubview:self.tableView];
}

#pragma mark- Actions
- (void)search {
    MLGMSearchViewController *vcSearch = [[MLGMSearchViewController alloc] init];
    UINavigationController *nav = [[MLGMNavigationController alloc] initWithRootViewController:vcSearch];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark- Public Methods

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGMTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.tapUserAction = ^(NSString *userName){
        MLGMUserPageViewController *vcUser = [[MLGMUserPageViewController alloc] init];
        vcUser.userName = userName;
        [self.navigationController pushViewController:vcUser animated:YES];
    };
    
    cell.tapSourceRepoAction = ^(NSString *source){
        MLGMRepoDetailController *vc = [[MLGMRepoDetailController alloc] init];
        vc.repoName = source;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    cell.tapForkRepoAction = ^(NSString *taget) {
        MLGMRepoDetailController *vc = [[MLGMRepoDetailController alloc] init];
        vc.repoName = taget;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    [cell configureCell:self.results[indexPath.row]];
    
    return cell;
}

#pragma mark- Override Parent Methods

- (void)updateViewConstraints {
    if (!_didSetupConstraints) {
        [self.tableView pinToSuperviewEdges:JRTViewPinAllEdges inset:0.0f];
        _didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark- Getter Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView autoLayoutView];
    }
    
    return _tableView;
}

- (NSMutableArray *)results {
    if (!_results) {
        _results = [NSMutableArray new];
    }
    
    return _results;
}

- (UIBarButtonItem *)rightBarButtonItem {
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                            target:self
                                                                            action:@selector(search)];
    }
    
    return _rightBarButtonItem;
}

#pragma mark- Helper Method

#pragma mark Temporary Area

@end
