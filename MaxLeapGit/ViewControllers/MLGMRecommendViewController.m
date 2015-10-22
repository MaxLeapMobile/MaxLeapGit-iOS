//
//  GMRecommendViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMRecommendViewController.h"


#define kVerticalSeparatorLineWidth         1
#define kToolBarButtonCount                 3
#define kToolBarButtonWidth                 (self.view.bounds.size.width - kVerticalSeparatorLineWidth) / kToolBarButtonCount

@interface MLGMRecommendViewController () <WKNavigationDelegate>
@property (nonatomic, assign) NSUInteger requestPageNumber;
@property (nonatomic, assign) BOOL didRequestedDataReachEnd;

@property (nonatomic, strong) NSMutableArray<MLGMRepo *> *repos;
@property (nonatomic, assign) NSUInteger currentRepoIndex;

@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, strong) UIView *toolbarView;
@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *forkButton;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIView *separatorLine1;
@property (nonatomic, strong) UIView *separatorLine2;
@property (nonatomic, strong) UIActivityIndicatorView *loadingViewAtStarButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingViewAtForkButton;

@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation MLGMRecommendViewController
#pragma mark - init Method

#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
   
    [self configureSubViews];
    [self updateViewConstraints];

    [self fetchDataAndUpdateContentViews];
}

- (void)fetchDataAndUpdateContentViews {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading...", @"")];
    [[MLGMWebService sharedInstance] fetchRecommendationReposFromPage:self.requestPageNumber  completion:^(NSArray *repos, BOOL isReachEnd, NSError *error) {
        [SVProgressHUD dismiss];
       
        self.didRequestedDataReachEnd = isReachEnd;
        
        [self updateRepos:repos];
        [self updateViews];
    }];
}

- (void)updateRepos:(NSArray *)repos {
    [repos enumerateObjectsUsingBlock:^(MLGMRepo *repo, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", repo.name];
        NSArray *filteredArray = [self.repos filteredArrayUsingPredicate:predicate];
        if (filteredArray.count == 0) {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repo.name];
            MLGMStarRelation *starRelation = [MLGMStarRelation MR_findFirstWithPredicate:p];
            if (!starRelation) {
                [self.repos addObject:repo];
            }
        }
    }];
    
    if  (kRecommendationDebug) {
        DDLogInfo(@"self.repos.count = %lu", self.repos.count);
    }
}

- (void)updateViews {
    if (self.repos.count == 0) {
        [self hideRepoWebViewAndShowEmptyView];
        self.currentRepoIndex = 0;
        
    } else if (self.repos.count > 0) {
        if (self.currentRepoIndex < self.repos.count) {
            [self showRepoWebView];
            
        } else if (self.currentRepoIndex == self.repos.count && self.didRequestedDataReachEnd) {
            [self hideRepoWebViewAndShowEmptyView];
            self.currentRepoIndex = 0;
        }
    }
}

- (void)hideRepoWebViewAndShowEmptyView {
    if (!self.emptyView.superview) {
        [self.view addSubview:self.emptyView];
    }
    self.emptyView.hidden = NO;
    self.starButton.enabled = _forkButton.enabled = _skipButton.enabled = NO;
    self.webView.hidden = YES;
    [self.webView stopLoading];
}

- (void)showRepoWebView {
    if (self.currentRepoIndex < self.repos.count) {
        MLGMRepo *currentRepo = self.repos[self.currentRepoIndex];
        if (currentRepo.htmlPageUrl.length) {
            self.title = currentRepo.name;
            self.webView.hidden = NO;
            [self.webView stopLoading];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentRepo.htmlPageUrl]]];
            self.emptyView.hidden = YES;
            self.starButton.enabled = _forkButton.enabled = _skipButton.enabled = YES;
        }
    }
}

#pragma mark- SubView Configuration
- (void)configureSubViews {
    [self configureNavigationBar];
    
    [self.view addSubview:self.toolbarView];
    [self.toolbarView addSubview:self.starButton];
    [self.toolbarView addSubview:self.forkButton];
    [self.toolbarView addSubview:self.skipButton];
    [self.toolbarView addSubview:self.separatorLine1];
    [self.toolbarView addSubview:self.separatorLine2];
    
    [self.starButton addSubview:self.loadingViewAtStarButton];
    [self.forkButton addSubview:self.loadingViewAtForkButton];
}

- (void)configureNavigationBar {
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(0, 0, 21, 12.5);
    [dismissButton setImage:ImageNamed(@"back_arrow_normal") forState:UIControlStateNormal];
    [dismissButton setImage:ImageNamed(@"back_arrow_selected") forState:UIControlStateHighlighted];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:ImageNamed(@"search_icon_normal") forState:UIControlStateNormal];
    [searchButton setImage:ImageNamed(@"search_icon_selected") forState:UIControlStateHighlighted];
    searchButton.frame = CGRectMake(0, 0, 18, 18);
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

#pragma mark - Actions
- (void)dismiss {
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)search {
    MLGMSearchViewController *vcSearch = [[MLGMSearchViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcSearch];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)onClickedStarButton {
    if (self.loadingViewAtStarButton.isAnimating) {
        return;
    }
    
    [self.starButton setTitle:@"" forState:UIControlStateNormal];
    [self.loadingViewAtStarButton startAnimating];
    
    MLGMRepo *currentRepo = self.repos[self.currentRepoIndex];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, currentRepo.name];
    MLGMStarRelation *starRelation = [MLGMStarRelation MR_findFirstWithPredicate:p];
    if (starRelation.isStar.boolValue) {
        [[MLGMWebService sharedInstance] unstarRepo:currentRepo.name completion:^(BOOL succeeded, NSString *repoName, NSError *error) {
            [self.loadingViewAtStarButton stopAnimating];
            
            if (succeeded) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"UnStar Success", nil)];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"UnStar Failure", nil)];
            }
            
            [self updateStarStateWithRepoName:repoName];
        }];
    } else {
        [[MLGMWebService sharedInstance] starRepo:currentRepo.name completion:^(BOOL succeeded, NSString *repoName, NSError *error) {
            if (succeeded) {
                [self.loadingViewAtStarButton stopAnimating];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Star Success", nil)];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Star Failure", nil)];
            }
            
            [self updateStarStateWithRepoName:repoName];
        }];
    }
}

- (void)onClickedForkButton {
    if (self.loadingViewAtForkButton.isAnimating) {
        return;
    }
    
    [self.loadingViewAtForkButton startAnimating];
    [self.forkButton setTitle:@"" forState:UIControlStateNormal];
    
    MLGMRepo *currentRepo = self.repos[self.currentRepoIndex];
    __weak typeof(self) weakSelf = self;
    [[MLGMWebService sharedInstance] forkRepo:currentRepo.name completion:^(BOOL succeeded, NSString *repoName, NSError *error) {
        [weakSelf.loadingViewAtForkButton stopAnimating];
        [weakSelf.forkButton setTitle:NSLocalizedString(@"Fork", nil) forState:UIControlStateNormal];
        
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Fork Success", nil)];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Fork Failure", nil)];
        }
    }];
}

- (void)onClickedSkipButton {
    self.currentRepoIndex++;
    
    [self updateViews];
    
    if (self.currentRepoIndex == self.repos.count && !self.didRequestedDataReachEnd) {
        self.requestPageNumber++;
        
        [self fetchDataAndUpdateContentViews];
    }
}

- (void)presentAddNewGenePage {
    MLGMNewGeneViewController *vcGenes = [[MLGMNewGeneViewController alloc] init];
    __weak typeof(self) wSelf = self;
    vcGenes.dismissBlock = ^{
        [wSelf fetchDataAndUpdateContentViews];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcGenes];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)replayRecommendationView {
    if (self.repos.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please add new genes first!" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *alertAction) {
            [weakSelf presentAddNewGenePage];
        }];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    self.currentRepoIndex = 0;
    [self updateViews];
}

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark- Override Parent Method
- (void)updateViewConstraints {
    if (!self.didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_toolbarView, _starButton, _separatorLine1, _forkButton, _separatorLine2, _skipButton, _loadingViewAtStarButton, _loadingViewAtForkButton);
      
        [self.loadingViewAtStarButton pinToSuperviewEdges:JRTViewPinTopEdge | JRTViewPinBottomEdge | JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0];
        [self.loadingViewAtForkButton pinToSuperviewEdges:JRTViewPinTopEdge | JRTViewPinBottomEdge | JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0];
        
        [self.toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_starButton]|" options:0 metrics:nil views:views]];
        [self.toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_starButton(==_forkButton,==_skipButton)][_forkButton][_skipButton]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
       
        [self.toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_starButton][_separatorLine1(1)]" options:0 metrics:nil views:views]];
        [self.toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_separatorLine2(1)][_skipButton]|" options:0 metrics:nil views:views]];
        [self.toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_separatorLine1(16)]" options:0 metrics:nil views:views]];
        [self.toolbarView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.toolbarView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_separatorLine2(16)]" options:0 metrics:nil views:views]];
        [self.toolbarView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.toolbarView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbarView(44)]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_toolbarView]|" options:0 metrics:nil views:views]];
        
        self.didSetUpConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark- Private Method
- (void)updateStarStateWithRepoName:(NSString *)repoName {
    [self.loadingViewAtStarButton stopAnimating];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repoName];
    MLGMStarRelation *starRelation = [MLGMStarRelation MR_findFirstWithPredicate:p];
    if (!starRelation.isStar) {
        [self.loadingViewAtStarButton startAnimating];
        return;
    }
    
    if (starRelation.isStar.boolValue) {
        [self.starButton setTitle:NSLocalizedString(@"UnStar", nil) forState:UIControlStateNormal];
    } else {
        [self.starButton setTitle:NSLocalizedString(@"Star", nil) forState:UIControlStateNormal];
    }
}

#pragma mark- Getter Setter
- (UIView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [UIView autoLayoutView];
        _toolbarView.backgroundColor = BottomToolBarColor;
    }
    return _toolbarView;
}

- (UIButton *)starButton {
    if (!_starButton) {
        _starButton = [self createButtonAtIndex:0 withTitle:NSLocalizedString(@"Star", @"") action:@selector(onClickedStarButton)];
    }
    return _starButton;
}

- (UIButton *)forkButton {
    if (!_forkButton) {
        _forkButton = [self createButtonAtIndex:1 withTitle:NSLocalizedString(@"Fork", @"") action:@selector(onClickedForkButton)];
    }
    return _forkButton;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [self createButtonAtIndex:2 withTitle:NSLocalizedString(@"Skip", @"") action:@selector(onClickedSkipButton)];
    }
    return _skipButton;
}

- (UIActivityIndicatorView *)loadingViewAtStarButton {
    if (!_loadingViewAtForkButton) {
        _loadingViewAtStarButton = [UIActivityIndicatorView autoLayoutView];
    }
    return _loadingViewAtStarButton;
}

- (UIActivityIndicatorView *)loadingViewAtForkButton {
    if (!_loadingViewAtForkButton) {
        _loadingViewAtForkButton = [UIActivityIndicatorView autoLayoutView];
    }
    return _loadingViewAtForkButton;
}

- (UIView *)separatorLine1 {
    if (!_separatorLine1) {
        _separatorLine1 = [UIView autoLayoutView];
        _separatorLine1.backgroundColor = [UIColor whiteColor];
    }
    return _separatorLine1;
}

- (UIView *)separatorLine2 {
    if (!_separatorLine2) {
        _separatorLine2 = [UIView autoLayoutView];
        _separatorLine2.backgroundColor = [UIColor whiteColor];
    }
    return _separatorLine2;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        __weak typeof(self) wSelf = self;
        _emptyView = [[MLGMRecommendEmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44)
                                                  addNewGeneAction:^{
                                                      [wSelf presentAddNewGenePage];
                                                  }
                                                      replayAction:^{
                                                          [wSelf replayRecommendationView];
                                                      }];
        _emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _emptyView;
}

- (NSMutableArray<MLGMRepo *> *)repos {
    if (!_repos) {
        _repos = [NSMutableArray array];
    }
    return _repos;
}

#pragma mark- Helper Method
- (UIButton *)createButtonAtIndex:(NSUInteger)index withTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton autoLayoutView];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x6aa9ff)] forState:UIControlStateDisabled];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
