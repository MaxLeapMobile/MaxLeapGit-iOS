//
//  MLGMReposController.m
//  MaxLeapGit
//
//  Created by Julie on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMReposViewController.h"

@interface MLGMReposViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MLGMReposViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubViews];
    [self updateViewConstraints];
    [self.tableView triggerPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self transparentNavigationBar:NO];
    [self.tableView reloadData];
}

#pragma mark- Override Parent Methods
- (void)updateViewConstraints {
    if (!_didSetupConstraints) {
        [self.tableView pinToSuperviewEdges:JRTViewPinAllEdges inset:0.0];
        _didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark- SubViews Configuration
- (void)configureSubViews {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (_type == MLGMReposControllerTypeRepos) {
        self.title = NSLocalizedString(@"Repos", @"");
    }
    
    if (_type == MLGMReposControllerTypeStars) {
        self.title = NSLocalizedString(@"Stars", @"");
    }
    [self.view addSubview:self.tableView];
}

#pragma mark- Actions

#pragma mark- Public Methods

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGMRepoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLGMRepoCell"];
    [cell configureCell:self.results[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MLGMRepoDetailController *repoDetailVC = [[MLGMRepoDetailController alloc] init];
    MLGMRepo *repo = self.results[indexPath.row];
    repoDetailVC.repoName = repo.name;
    [self.navigationController pushViewController:repoDetailVC animated:YES];
}

#pragma mark- Getter Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView autoLayoutView];
        [_tableView registerClass:[MLGMRepoCell class] forCellReuseIdentifier:@"MLGMRepoCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 105;
        
        __weak typeof(self) weakSelf = self;
        __block int page = 1;
        [self.tableView addPullToRefreshWithActionHandler:^{
            weakSelf.tableView.showsInfiniteScrolling = NO;
            page = 1;
            if (self.type == MLGMReposControllerTypeRepos) {
                [[MLGMAccountManager sharedInstance] fetchPublicReposForUserName:weakSelf.ownerName fromPage:page completion:^(NSArray *repos, BOOL isReachEnd, NSError *error) {
                    execute_after_main_queue(0.2, ^{
                        [weakSelf.tableView.pullToRefreshView stopAnimating];
                    });
                    weakSelf.tableView.showsInfiniteScrolling = !isReachEnd;
                    
                    if (!error) {
                        [weakSelf.results removeAllObjects];
                        [weakSelf.results addObjectsFromArray:repos];
                        [weakSelf.tableView reloadData];
                    } else {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                    }
                }];
            }
            
            if (self.type == MLGMReposControllerTypeStars) {
                [[MLGMAccountManager sharedInstance] fetchStarredReposForUserName:weakSelf.ownerName fromPage:page completion:^(NSArray *repos, BOOL isReachEnd, NSError *error) {
                    execute_after_main_queue(0.2, ^{
                        [weakSelf.tableView.pullToRefreshView stopAnimating];
                    });
                    weakSelf.tableView.showsInfiniteScrolling = !isReachEnd;
                    
                    if (!error) {
                        [weakSelf.results removeAllObjects];
                        [weakSelf.results addObjectsFromArray:repos];
                        [weakSelf.tableView reloadData];
                    } else {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                    }
                }];
            }
        }];
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            if (self.type == MLGMReposControllerTypeRepos) {
                [[MLGMAccountManager sharedInstance] fetchPublicReposForUserName:weakSelf.ownerName fromPage:page + 1 completion:^(NSArray *repos, BOOL isReachEnd, NSError *error) {
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                    weakSelf.tableView.showsInfiniteScrolling = !isReachEnd;
                    if (!error) {
                        page++;
                        [weakSelf.results addObjectsFromArray:repos];
                        [weakSelf.tableView reloadData];
                    } else {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                    }
                }];
            }
            
            if (self.type == MLGMReposControllerTypeStars) {
                [[MLGMAccountManager sharedInstance] fetchStarredReposForUserName:weakSelf.ownerName fromPage:page + 1 completion:^(NSArray *repos, BOOL isReachEnd, NSError *error) {
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                    weakSelf.tableView.showsInfiniteScrolling = !isReachEnd;
                    if (!error) {
                        page++;
                        [weakSelf.results addObjectsFromArray:repos];
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
