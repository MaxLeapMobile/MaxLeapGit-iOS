//
//  MLGMOrganizationsController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMOrganizationsViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "MLGMFollowCell.h"
#import "MLGMTabBarController.h"
#import "MLGMWebViewController.h"

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
    [self.view addSubview:self.tableView];
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self transparentNavigationBar:NO];
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
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

#pragma mark- Actions

#pragma mark- Public Methods

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MLGMFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MLGMWebViewController *vc = [[MLGMWebViewController alloc] init];
    vc.url = @"https://github.com/dailymotion";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- Getter Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView autoLayoutView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        
        __weak typeof(self) weakSelf = self;
        __block int page = 1;
        [self.tableView addPullToRefreshWithActionHandler:^{
            weakSelf.tableView.showsInfiniteScrolling = NO;
            page = 1;
             [[MLGMWebService sharedInstance] organizationsForUserName:weakSelf.orgName fromPage:page + 1 completion:^(NSArray *orgMOCs, BOOL isRechEnd, NSError *error) {
                execute_after_main_queue(0.2, ^{
                    [weakSelf.tableView.pullToRefreshView stopAnimating];
                });
                weakSelf.tableView.showsInfiniteScrolling = !isRechEnd;
                
                if (!error) {
                    [weakSelf.results removeAllObjects];
                    [weakSelf.results addObjectsFromArray:orgMOCs];
                    [weakSelf.tableView reloadData];
                } else {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
                }
            }];
        }];
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [[MLGMWebService sharedInstance] organizationsForUserName:weakSelf.orgName fromPage:page + 1 completion:^(NSArray *orgMOCs, BOOL isRechEnd, NSError *error) {
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                weakSelf.tableView.showsInfiniteScrolling = !isRechEnd;
                if (!error) {
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

#pragma mark- Helper Method

#pragma mark Temporary Area

@end
