//
//  GMSearchViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMSearchViewController.h"

#define kRepoAndUserButtonWidth     77

@interface MLGMSearchViewController () <UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, WYPopoverControllerDelegate, MLGMSortViewControllerDelegate>
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) MLGMSearchPageTitleView *titleView;

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UITableView *repoTableView;
@property (nonatomic, strong) UITableView *userTableView;

@property (nonatomic, strong) UILabel *emptyView;

@property (nonatomic, strong) UIView *scrollIndicator;

@property (nonatomic, strong) WYPopoverController *popover;

@property (nonatomic, assign) BOOL searchTargetIsUser;
@property (nonatomic, strong) NSString *searchText;
//results
@property (nonatomic, strong) NSMutableArray *repos;
@property (nonatomic, assign) MLGMSearchRepoSortType repoSortType;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, assign) MLGMSearchUserSortType userSortType;

@end

@implementation MLGMSearchViewController

#pragma mark - init Method

#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self transparentNavigationBar:NO];
    [(MLGMCustomTabBarController *)self.navigationController.tabBarController setTabBarHidden:NO];
}


#pragma mark - SubView Configuration
- (void)configureUI {
    [self configureSearchController];
    [self configureTitleView];
    [self configureContentView];
    [self configureScrollIndicator];
}

- (void)configureSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.delegate = self;
    _searchController.searchBar.delegate = self;
    self.navigationItem.titleView = _searchController.searchBar;
}

- (void)configureTitleView {
    _titleView = [[MLGMSearchPageTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    __weak typeof(self) wSelf = self;
    _titleView.repoButtonAction = ^{
        [wSelf onClickedRepoButton];
    };
    _titleView.userButtonAction = ^{
        [wSelf onClickedUserButton];
    };
    _titleView.sortOrderAction = ^{
        [wSelf onClickedSortButton];
    };
    
    _titleView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _titleView.backgroundColor = ThemeNavigationBarColor;
    [self.view addSubview:_titleView];
}

- (void)configureContentView {
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40 - 64)];
    _contentView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, _contentView.bounds.size.height);
    _contentView.showsHorizontalScrollIndicator = YES;
    _contentView.pagingEnabled = YES;
    _contentView.delegate = self;
    [self.view addSubview:_contentView];
    
    _repoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
    _repoTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _repoTableView.dataSource = self;
    _repoTableView.delegate = self;
    _repoTableView.tableFooterView = [[UIView alloc] init];
    _repoTableView.rowHeight = UITableViewAutomaticDimension;
    _repoTableView.estimatedRowHeight = 105;
    [_contentView addSubview:_repoTableView];
    
    _userTableView = [[UITableView alloc]initWithFrame:CGRectMake(_contentView.bounds.size.width, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
    _userTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _userTableView.dataSource = self;
    _userTableView.delegate = self;
    _userTableView.tableFooterView = [[UIView alloc] init];
    [_contentView addSubview:_userTableView];
    
    __weak typeof(self) wSelf = self;
    __block NSUInteger repoPage = 1;
    [_repoTableView addInfiniteScrollingWithActionHandler:^{
        if (!wSelf.searchText.length) {
            [wSelf.repoTableView.infiniteScrollingView stopAnimating];
            return;
        }
        
        [KSharedWebService searchByRepoName:wSelf.searchText sortType:wSelf.repoSortType fromPage:repoPage + 1 completion:^(NSArray *repos, BOOL isReachEnd, NSError *error) {
            [wSelf.repoTableView.infiniteScrollingView stopAnimating];
            wSelf.repoTableView.showsInfiniteScrolling = !isReachEnd;
            if (!error) {
                repoPage++;
                [wSelf.repos addObjectsFromArray:repos];
                [wSelf.repoTableView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", @"")];
            }
        }];
    }];
    
    __block NSUInteger userPage = 1;
    [_userTableView addInfiniteScrollingWithActionHandler:^{
        if (!wSelf.searchText.length) {
            [wSelf.repoTableView.infiniteScrollingView stopAnimating];
            return;
        }
        
        [KSharedWebService searchByUserName:wSelf.searchText sortType:wSelf.userSortType fromPage:userPage + 1 completion:^(NSArray *repos, BOOL isReachEnd, NSError *error) {
            [wSelf.userTableView.infiniteScrollingView stopAnimating];
            wSelf.userTableView.showsInfiniteScrolling = !isReachEnd;
            if (!error) {
                userPage++;
                [wSelf.users addObjectsFromArray:repos];
                [wSelf.userTableView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", @"")];
            }
        }];
    }];
    
    _emptyView = [[UILabel alloc] initWithFrame:_contentView.bounds];
    _emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _emptyView.text = NSLocalizedString(@"No Results", @"");
    _emptyView.textColor = UIColorFromRGB(0xBFBFBF);
    _emptyView.font = [UIFont systemFontOfSize:27];
    _emptyView.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_emptyView];
    [self showEmptyViewIfNeeded];
}

- (void)configureScrollIndicator {
    CGFloat originY = _titleView.bounds.origin.y + _titleView.bounds.size.height;
    _scrollIndicator = [[UIView alloc] initWithFrame:CGRectMake(10, originY - 2, kRepoAndUserButtonWidth - 20, 2)];
    _scrollIndicator.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollIndicator];
}

#pragma mark - Actions
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickedSortButton {
    MLGMSortGroupType sortGroupType = _searchTargetIsUser ? MLGMSortGroupTypeUser : MLGMSortGroupTypeRepo;
    NSUInteger currentSortTypeIndex = _searchTargetIsUser ? _userSortType : _repoSortType;
    MLGMSortViewController *vc = [[MLGMSortViewController alloc] initWithGroupType:sortGroupType selectedIndex:currentSortTypeIndex];
    vc.preferredContentSize = CGSizeMake(250, 44 * 4);
    vc.delegate = self;
    
    _popover = [[WYPopoverController alloc] initWithContentViewController:vc];
    _popover.delegate = self;
    [_popover presentPopoverFromRect:CGRectMake(self.view.bounds.size.width - 80, _titleView.bounds.size.height -10, 0, 0) inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

- (void)onClickedRepoButton {
    if (_searchTargetIsUser) {
        _searchTargetIsUser = NO;
        [self scrollToTableViewWithCurrentSearchGroup];
        if ([_repos count] == 0) {
            [self searchDataAndReloadTableView];
        }
    }
}

- (void)onClickedUserButton {
    if (!_searchTargetIsUser) {
        _searchTargetIsUser = YES;
        [self scrollToTableViewWithCurrentSearchGroup];
        if ([_users count] == 0) {
            [self searchDataAndReloadTableView];
        }
    }
}

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark - UISearchController Delegate
- (void)didPresentSearchController:(UISearchController *)searchController {
    _searchController.searchBar.showsCancelButton = NO;
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchDataAndReloadTableView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchText = searchText;
}

#pragma mark - UITableView Data Source & Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _repoTableView) {
        return UITableViewAutomaticDimension;
    } else {
        return 60;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _repoTableView) {
        return _repos.count;
    } else {
        return _users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = (tableView == _repoTableView) ? @"repoCell" : @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableView == _repoTableView) {
        if (!cell) {
            cell = [[MLGMRepoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        if (indexPath.row < _repos.count) {
            MLGMRepo *repo = _repos[indexPath.row];
            MLGMRepoCell *repoCell = (MLGMRepoCell *)cell;
            [repoCell configureCell:repo];
        }
    } else {
        if (!cell) {
            cell = [[MLGMFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        if (indexPath.row < _users.count) {
            MLGMActorProfile *actorProfile = _users[indexPath.row];
            MLGMFollowCell *userCell = (MLGMFollowCell *)cell;
            userCell.isForSearchPage = YES;
            [userCell configureCell:actorProfile];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _repoTableView) {
        MLGMRepoDetailController *repoVC = [[MLGMRepoDetailController alloc] init];
        MLGMRepo *repo = _repos[indexPath.row];
        repoVC.repoName = repo.name;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [self.navigationController pushViewController:repoVC animated:YES];
    } else {
        MLGMHomePageViewController *userVC = [[MLGMHomePageViewController alloc] init];
        MLGMActorProfile *user =  _users[indexPath.row];
        userVC.ownerName = user.loginName;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _contentView) {
        BOOL currentTargetIsUser = _contentView.contentOffset.x == self.view.bounds.size.width;
        if (currentTargetIsUser != _searchTargetIsUser) {
            _searchTargetIsUser = currentTargetIsUser;
            [self scrollToTableViewWithCurrentSearchGroup];
            if (_searchText.length) {
                [self searchDataAndReloadTableView];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _repoTableView || scrollView == _userTableView) {
        [_searchController.searchBar endEditing:YES];
    }
}

#pragma mark - WYPopoverController Delegate
- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller {
    _popover.delegate = nil;
    _popover = nil;
}

#pragma mark - MLGMSortViewController Delegate
- (void)sortViewControllerDidSelectRowAtIndex:(NSUInteger)index {
    if (!_searchTargetIsUser) {
        if (_repoSortType != (MLGMSearchRepoSortType)index) {
            _repoSortType = (MLGMSearchRepoSortType)index;
            [self searchDataAndReloadTableView];
        }
    } else {
        if (_userSortType != (MLGMSearchUserSortType)index) {
            _userSortType = (MLGMSearchUserSortType)index;
            [self searchDataAndReloadTableView];
        }
    }
    [_popover dismissPopoverAnimated:YES];
}

#pragma mark- Private Method
- (void)searchDataAndReloadTableView {
    if (!_searchText.length) {
        [SVProgressHUD dismiss];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    _emptyView.hidden = YES;
    
    if (!_searchTargetIsUser) {
        if (!_repos) {
            _repos = [NSMutableArray array];
        }
        
        __weak typeof(self) wSelf = self;
        [KSharedWebService searchByRepoName:_searchText sortType:_repoSortType fromPage:1 completion:^(NSArray *repos, BOOL isReachEnd, NSError *error) {
            [SVProgressHUD dismiss];
           
            if (isReachEnd) {
                wSelf.userTableView.showsInfiniteScrolling = !isReachEnd;
            }
            [wSelf.repos removeAllObjects];
            [wSelf.repos addObjectsFromArray:repos];
            [wSelf.repoTableView reloadData];
            if (repos.count > 0) {
                [wSelf.repoTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            [wSelf showEmptyViewIfNeeded];
        }];
    } else {
        if (!_users) {
            _users = [NSMutableArray array];
        }
        
        __weak typeof(self) wSelf = self;
        [KSharedWebService searchByUserName:_searchText sortType:_userSortType fromPage:1 completion:^(NSArray *users, BOOL isReachEnd, NSError *error) {
            [SVProgressHUD dismiss];
           
            if (isReachEnd) {
                wSelf.userTableView.showsInfiniteScrolling = !isReachEnd;
            }
            [wSelf.users removeAllObjects];
            [wSelf.users addObjectsFromArray:users];
            [wSelf.userTableView reloadData];
            if (users.count > 0) {
                [wSelf.userTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            [wSelf showEmptyViewIfNeeded];
        }];
    }
}

- (void)scrollToTableViewWithCurrentSearchGroup {
    //update scrollIndicator position
    CGFloat indicatorOriginX = _searchTargetIsUser ? 10 + kRepoAndUserButtonWidth : 10;
    _scrollIndicator.frame = CGRectMake(indicatorOriginX, _titleView.bounds.origin.y + _titleView.bounds.size.height - 2, kRepoAndUserButtonWidth - 10 * 2, 2);
    CGFloat scrollViewOffsetX = _searchTargetIsUser ? self.view.bounds.size.width : 0;
    _contentView.contentOffset = CGPointMake(scrollViewOffsetX, 0);
    
    [self showEmptyViewIfNeeded];
}

- (void)showEmptyViewIfNeeded {
    if ((_searchTargetIsUser && _users.count == 0) || (!_searchTargetIsUser && _repos.count == 0)) {
        CGFloat originX = _searchTargetIsUser ? _contentView.bounds.size.width : 0;
        _emptyView.frame = CGRectMake(originX, 0, _contentView.bounds.size.width, _contentView.bounds.size.height);
        _emptyView.hidden = NO;
    } else {
        _emptyView.hidden = YES;
    }
}

#pragma mark- Getter Setter


#pragma mark- Helper Method

@end

