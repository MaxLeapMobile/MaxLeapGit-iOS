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

@interface MLGMSearchViewController () <UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, WYPopoverControllerDelegate, MLGMSortViewControllerDelegate>
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *repoButton;
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIButton *sortButton;

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UITableView *repoTableView;
@property (nonatomic, strong) UITableView *userTableView;

@property (nonatomic, strong) UIView *scrollIndicator;

@property (nonatomic, strong) WYPopoverController *popover;

@property (nonatomic, assign) BOOL searchTargetIsUser;
@property (nonatomic, strong) NSString *sortMethod;

//results
@property (nonatomic, strong) NSArray *repos;
@property (nonatomic, strong) NSArray *users;

@end

@implementation MLGMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];

    [self configureUI];
}

- (void)setSearchTargetIsUser:(BOOL)searchTargetIsUser {
    if (_searchTargetIsUser != searchTargetIsUser) {
        _searchTargetIsUser = searchTargetIsUser;
        _sortMethod = nil;
    }
}

#pragma mark - SubView Configuration
- (void)configureUI {
    [self configureSearchController];
    [self configureTitleView];
    [self configureContentView];
}

- (void)configureSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.delegate = self;
    self.navigationItem.titleView = _searchController.searchBar;
}

- (void)configureTitleView {
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    _titleView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _titleView.backgroundColor = ThemeNavigationBarColor;
    [self.view addSubview:_titleView];
    
    _repoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _repoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_repoButton setTitle:NSLocalizedString(@"Repo", @"") forState:UIControlStateNormal];
    [_repoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_repoButton addTarget:self action:@selector(onClickedRepoButton) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_repoButton];
    
    _userButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _userButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_userButton setTitle:NSLocalizedString(@"User", @"") forState:UIControlStateNormal];
    [_userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_userButton addTarget:self action:@selector(onClickedUserButton) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_userButton];
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    _separatorLine.backgroundColor = [UIColor whiteColor];
    [_titleView addSubview:_separatorLine];
    
    _sortButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sortButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_sortButton setTitle:NSLocalizedString(@"Sort by", @"") forState:UIControlStateNormal];
    [_sortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sortButton addTarget:self action:@selector(onClickedSortButton) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_sortButton];
    
    [self updateTitleViewConstraints];
}

- (void)updateTitleViewConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_repoButton, _userButton, _sortButton, _separatorLine);
    [_titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_repoButton(100)][_userButton(100)][_separatorLine(2)][_sortButton]-10-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    [_titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_repoButton]|" options:0 metrics:nil views:views]];
}

- (void)configureContentView {
    CGFloat originY = _titleView.bounds.origin.y + _titleView.bounds.size.height;
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
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
    [_contentView addSubview:_repoTableView];
    
    _userTableView = [[UITableView alloc]initWithFrame:CGRectMake(_contentView.bounds.size.width, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
    _userTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _userTableView.dataSource = self;
    _userTableView.delegate = self;
    _userTableView.tableFooterView = [[UIView alloc] init];
    [_contentView addSubview:_userTableView];
    
    //content indicator
    _scrollIndicator = [[UIView alloc] initWithFrame:CGRectMake(30, originY - 2, 50, 2)];
    _scrollIndicator.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollIndicator];
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

#pragma mark - UISearchController Delegate
- (void)didPresentSearchController:(UISearchController *)searchController {
    _searchController.searchBar.showsCancelButton = NO;
}

#pragma mark - UITableView Data Source & Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _repoTableView) {
        return 80;
    } else {
        return 60;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //temp
    return 5;
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
    CGFloat indicatorOriginX = _searchTargetIsUser ? 30 + 100 : 30;
    _scrollIndicator.frame = CGRectMake(indicatorOriginX, _titleView.bounds.origin.y + _titleView.bounds.size.height - 2, 50, 2);
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
  
}

@end
