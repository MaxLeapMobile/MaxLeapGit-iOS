//
//  GMSearchViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMSearchViewController.h"
#import "MLGMRepoCell.h"
#import "MLGMUserCell.h"
#import "WYPopoverController.h"
#import "MLGMSortViewController.h"
#import "MLGMRepoDetailController.h"
#import "MLGMSearchPageTitleView.h"

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
@property (nonatomic, strong) NSString *sortMethod;

//results
@property (nonatomic, strong) NSArray *repos;
@property (nonatomic, strong) NSArray *users;

@end

@implementation MLGMSearchViewController

#pragma mark - init Method

#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];

    [self configureUI];
}


#pragma mark - SubView Configuration
- (void)configureUI {
    [self configureSearchController];
    [self configureTitleView];
    [self configureContentView];
    [self configureEmptyView];
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
    CGFloat originY = _titleView.bounds.origin.y + _titleView.bounds.size.height;
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
    _contentView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, _contentView.bounds.size.height);
    _contentView.showsHorizontalScrollIndicator = YES;
    _contentView.pagingEnabled = YES;
    _contentView.delegate = self;
    [self.view addSubview:_contentView];
    
    _repoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height - 64)];
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
    
    //content indicator
    _scrollIndicator = [[UIView alloc] initWithFrame:CGRectMake(10, originY - 2, kRepoAndUserButtonWidth - 20, 2)];
    _scrollIndicator.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollIndicator];
}

- (void)configureEmptyView {
    _emptyView = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 104)];
    _emptyView.text = NSLocalizedString(@"No Results", @"");
    _emptyView.textColor = UIColorFromRGB(0xBFBFBF);
    _emptyView.font = [UIFont systemFontOfSize:27];
    _emptyView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_emptyView];
}

#pragma mark - Actions
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickedSortButton {
    MLGMSortGroupType sortGroupType = _searchTargetIsUser ? MLGMSortGroupTypeUser : MLGMSortGroupTypeRepo;
    MLGMSortViewController *vc = [[MLGMSortViewController alloc] initWithSortGroupType:sortGroupType selectedSortMethod:_sortMethod];
    vc.preferredContentSize = CGSizeMake(250, 44 * 4);
    vc.delegate = self;
    
    _popover = [[WYPopoverController alloc] initWithContentViewController:vc];
    _popover.delegate = self;
    [_popover presentPopoverFromRect:CGRectMake(self.view.bounds.size.width - 80, _titleView.bounds.size.height -10, 0, 0) inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

- (void)onClickedRepoButton {
    [self updateContentViewWithSearchTargetStatus:NO];
}

- (void)onClickedUserButton {
    [self updateContentViewWithSearchTargetStatus:YES];
}


#pragma mark- Delegate，DataSource, Callback Method

#pragma mark - UISearchController Delegate
- (void)didPresentSearchController:(UISearchController *)searchController {
    _searchController.searchBar.showsCancelButton = NO;
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //search and reload data
    //temp
    _repos = @[@"1"];
    _users = @[@"1"];
    
    [self requestDataAndReloadTableView];
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
    if (!cell) {
        if (tableView == _repoTableView) {
            cell = [[MLGMRepoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        } else {
            cell = [[MLGMUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _repoTableView) {
        UIViewController *vc = [[MLGMRepoDetailController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _contentView) {
        BOOL searchTargetIsUser = _contentView.contentOffset.x == self.view.bounds.size.width;
        [self updateContentViewWithSearchTargetStatus:searchTargetIsUser];
    }
}

- (void)updateContentViewWithSearchTargetStatus:(BOOL)searchTargetIsUser {
    [self setSearchTargetIsUser:searchTargetIsUser];
    
    //update scrollIndicator position
    CGFloat indicatorOriginX = _searchTargetIsUser ? 10 + kRepoAndUserButtonWidth : 10;
    _scrollIndicator.frame = CGRectMake(indicatorOriginX, _titleView.bounds.origin.y + _titleView.bounds.size.height - 2, kRepoAndUserButtonWidth - 10 * 2, 2);
    CGFloat scrollViewOffsetX = _searchTargetIsUser ? self.view.bounds.size.width : 0;
    _contentView.contentOffset = CGPointMake(scrollViewOffsetX, 0);
}

#pragma mark - WYPopoverController Delegate
- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller {
    _popover.delegate = nil;
    _popover = nil;
}

#pragma mark - MLGMSortViewController Delegate
- (void)sortViewControllerDidSelectSortMethod:(NSString *)sortMethod {
    _sortMethod = sortMethod;
    [_popover dismissPopoverAnimated:YES];
    
    //search and reload data
    [self requestDataAndReloadTableView];
}

#pragma mark- Private Method
- (void)requestDataAndReloadTableView {
    if ((_repos.count == 0 && !_searchTargetIsUser) || (_users.count == 0 && _searchTargetIsUser)) {
        _emptyView.hidden = NO;
    } else {
        _emptyView.hidden = YES;
    }
    
    [_repoTableView reloadData];
    [_userTableView reloadData];
}

#pragma mark- Getter Setter
- (void)setSearchTargetIsUser:(BOOL)searchTargetIsUser {
    if (_searchTargetIsUser != searchTargetIsUser) {
        _searchTargetIsUser = searchTargetIsUser;
        _sortMethod = nil;
    }
}

#pragma mark- Helper Method

@end
