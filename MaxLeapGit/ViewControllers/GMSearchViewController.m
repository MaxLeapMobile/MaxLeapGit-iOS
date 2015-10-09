//
//  GMSearchViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "GMSearchViewController.h"
#import "GMRepoCell.h"
#import "GMUserCell.h"

@interface GMSearchViewController () <UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
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

@property (nonatomic, strong) UIPopoverController *popover;

//results
@property (nonatomic, strong) NSArray *repos;
@property (nonatomic, strong) NSArray *users;

@end

@implementation GMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];

    [self configureUI];
}

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
    [_titleView addSubview:_repoButton];
    
    _userButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _userButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_userButton setTitle:NSLocalizedString(@"User", @"") forState:UIControlStateNormal];
    [_userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

}

- (void)showPopoverForIPad {
    if (!_popover) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.preferredContentSize = CGSizeMake(250, 44 * 4);
        _popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    }
    
    if (!_popover.isPopoverVisible) {
        [_popover presentPopoverFromRect:CGRectMake(self.view.bounds.size.width - 30, -10, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [_popover dismissPopoverAnimated:YES];
    }
}

#pragma mark - UISearchController Delegate
- (void)didPresentSearchController:(UISearchController *)searchController {
    _searchController.searchBar.showsCancelButton = NO;
}

#pragma mark - UITableView Data Source
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
            cell = [[GMRepoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        } else {
            cell = [[GMUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
    }
    return cell;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _contentView) {
        CGFloat indicatorOriginX = (_contentView.contentOffset.x == 0) ? 30 : 30 + 100;
        _scrollIndicator.frame = CGRectMake(indicatorOriginX, _titleView.bounds.origin.y + _titleView.bounds.size.height - 2, 50, 2);
    }
}

@end
