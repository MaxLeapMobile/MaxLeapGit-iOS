//
//  MLGMOrganizationsController.m
//  MaxLeapGit
//
//  Created by Li Zhu on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMOrganizationsViewController.h"

@interface MLGMOrganizationsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MLGMOrganizationsViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Organization", @"");
    [self configureSubViews];
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self transparentNavigationBar:NO];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.view addSubview:self.tableView];
}

#pragma mark- Actions

#pragma mark- Public Methods

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGMOrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLGMOrganizationCell"];
    [cell configureCell:self.results[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLGMActorProfile *actorProfile = self.results[indexPath.row];
    MLGMWebViewController *webViewVC = [[MLGMWebViewController alloc] init];
    webViewVC.url = [NSString stringWithFormat:@"https://github.com/%@", actorProfile.loginName];
    [self.navigationController pushViewController:webViewVC animated:YES];
}

#pragma mark- Getter Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView autoLayoutView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[MLGMOrganizationCell class] forCellReuseIdentifier:@"MLGMOrganizationCell"];
        
        __weak typeof(self) weakSelf = self;
        __block int page = 1;
        [self.tableView addPullToRefreshWithActionHandler:^{
            weakSelf.tableView.showsInfiniteScrolling = NO;
            page = 1;
             [[MLGMAccountManager sharedInstance] fetchOrganizationInfoForUserName:weakSelf.ownerName fromPage:page completion:^(NSArray *orgMOs, BOOL isReachEnd, NSError *error) {
                execute_after_main_queue(0.2, ^{
                    [weakSelf.tableView.pullToRefreshView stopAnimating];
                });
                weakSelf.tableView.showsInfiniteScrolling = !isReachEnd;
                
                if (!error) {
                    [weakSelf.results removeAllObjects];
                    [weakSelf.results addObjectsFromArray:orgMOs];
                    [weakSelf.tableView reloadData];
                } else {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                }
            }];
        }];
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [[MLGMAccountManager sharedInstance] fetchOrganizationInfoForUserName:weakSelf.ownerName fromPage:page + 1 completion:^(NSArray *orgMOCs, BOOL isReachEnd, NSError *error) {
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                weakSelf.tableView.showsInfiniteScrolling = !isReachEnd;
                if (!error && [orgMOCs count] > 0) {
                    page++;
                    [weakSelf.results addObjectsFromArray:orgMOCs];
                    [weakSelf.tableView reloadData];
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
