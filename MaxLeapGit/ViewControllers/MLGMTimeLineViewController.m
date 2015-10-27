//
//  GMTimeLineViewController.m
//  MaxLeapGit
//
//  Created by Julie on 15/10/8.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMTimeLineViewController.h"

@interface MLGMTimeLineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL didInitLoaded;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MLGMTimeLineViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubViews];
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self transparentNavigationBar:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (kOnlineAccount && !_didInitLoaded) {
        [self.tableView triggerPullToRefresh];
        _didInitLoaded = YES;
    }
}

#pragma mark- SubViews Configuration
- (void)configureSubViews {
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithNormalImagenName:@"search_icon_normal"
                                                                              selectedImageName:@"search_icon_selected"
                                                                                         target:self
                                                                                         action:@selector(searchButtonPressed:)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark- Actions
- (void)searchButtonPressed:(id)sender {
    MLGMSearchViewController *vcSearch = [[MLGMSearchViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcSearch];
    nav.navigationBar.barStyle = UIBarStyleBlack;
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
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGMTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.tapUserAction = ^(NSString *userName){
        MLGMHomePageViewController *homePageVC = [[MLGMHomePageViewController alloc] init];
        homePageVC.ownerName = userName;
        homePageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:homePageVC animated:YES];
    };
    
    cell.tapSourceRepoAction = ^(NSString *source){
        MLGMRepoDetailController *repoDetailVC = [[MLGMRepoDetailController alloc] init];
        repoDetailVC.repoName = source;
        repoDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:repoDetailVC animated:YES];
    };
    
    cell.tapForkRepoAction = ^(NSString *taget) {
        MLGMRepoDetailController *repoDetailVC = [[MLGMRepoDetailController alloc] init];
        repoDetailVC.repoName = taget;
        repoDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:repoDetailVC animated:YES];
    };
    
    [cell configureCell:self.results[indexPath.row]];
    
    return cell;
}

#pragma mark- Override Parent Methods
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

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
        [_tableView registerClass:[MLGMTimeLineCell class] forCellReuseIdentifier:@"Cell"];
        UIEdgeInsets adjustForTabbarInsets = (UIEdgeInsets){0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0};
        _tableView.contentInset = adjustForTabbarInsets;
        _tableView.scrollIndicatorInsets = adjustForTabbarInsets;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    	self.tableView.estimatedRowHeight = 80.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        __weak typeof(self) weakSelf = self;
        __block int page = 1;
        [weakSelf.tableView addPullToRefreshWithActionHandler:^{
            self.tableView.showsInfiniteScrolling = NO;
            page = 1;
            [kWebService fetchTimeLineEventsForUserName:kOnlineUserName
                                                        fromPage:page
                                                      completion:^(NSArray *events, BOOL isReachEnd, NSError *error) {
                                                          if (!isReachEnd && events.count < kPerPage) {
                                                              [self.tableView triggerInfiniteScrolling];
                                                          }
                                                          execute_after_main_queue(0.2, ^{
                                                              [weakSelf.tableView.pullToRefreshView stopAnimating];
                                                          });
                                                          weakSelf.tableView.showsInfiniteScrolling = !isReachEnd;
                                                          
                                                          if (!error) {
                                                              [weakSelf.results removeAllObjects];
                                                              [weakSelf.results addObjectsFromArray:events];
                                                              [weakSelf.tableView reloadData];
                                                          } else {
                                                              [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                                                          }
                                                      }];
        }];
        
        [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
            [kWebService fetchTimeLineEventsForUserName:kOnlineUserName
                                                        fromPage:page + 1
                                                      completion:^(NSArray *events, BOOL isReachEnd, NSError *error) {
                                                          [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                                          weakSelf.tableView.showsInfiniteScrolling = !isReachEnd;
                                                          if (!error) {
                                                              page++;
                                                              [weakSelf.results addObjectsFromArray:events];
                                                              [weakSelf.tableView reloadData];
                                                              if (!isReachEnd && events.count < 5) {
                                                                  [self.tableView triggerInfiniteScrolling];
                                                              }
                                                          } else {
                                                              [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                                                          }
                                                      }];
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
