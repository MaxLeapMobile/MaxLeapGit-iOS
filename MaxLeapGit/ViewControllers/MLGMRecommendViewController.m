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

@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *forkButton;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingViewAtStarButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingViewAtForkButton;
@end

@implementation MLGMRecommendViewController
#pragma mark - init Method

#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureNavigationBar];
    [self configureToolbarView];

    [self fetchDataAndUpdateViews];
}

- (void)fetchDataAndUpdateViews {
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
    _starButton.enabled = _forkButton.enabled = _skipButton.enabled = NO;
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
            _starButton.enabled = _forkButton.enabled = _skipButton.enabled = YES;
        }
    }
}

#pragma mark- SubView Configuration
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

- (void)configureToolbarView {
    UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64 - 44, self.view.bounds.size.width, 44)];
    toolbarView.backgroundColor = BottomToolBarColor;
    [self.view addSubview:toolbarView];

    _starButton = [self createButtonAtIndex:0 withTitle:NSLocalizedString(@"Star", @"") action:@selector(onClickedStarButton)];
    [toolbarView addSubview:_starButton];
    
    _forkButton = [self createButtonAtIndex:1 withTitle:NSLocalizedString(@"Fork", @"") action:@selector(onClickedForkButton)];
    [toolbarView addSubview:_forkButton];
    
    _loadingViewAtStarButton = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _loadingViewAtStarButton.center = [toolbarView convertPoint:_starButton.center toView:_starButton];
    [_starButton addSubview:_loadingViewAtStarButton];
    
    _loadingViewAtForkButton = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _loadingViewAtForkButton.center = [toolbarView convertPoint:_forkButton.center toView:_forkButton];
    [_forkButton addSubview:_loadingViewAtForkButton];
    
    _skipButton = [self createButtonAtIndex:2 withTitle:NSLocalizedString(@"Skip", @"") action:@selector(onClickedSkipButton)];
    [toolbarView addSubview:_skipButton];
    
    for (NSUInteger i = 0; i < kToolBarButtonCount; i++) {
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kToolBarButtonWidth + (kToolBarButtonWidth + kVerticalSeparatorLineWidth) * i, (44 - 16) / 2, kVerticalSeparatorLineWidth, 16)];
        separatorLine.backgroundColor = [UIColor whiteColor];
        [toolbarView addSubview:separatorLine];
    }
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
        [[MLGMWebService sharedInstance] unstarRepo:currentRepo.name completion:^(BOOL success, NSString *repoName, NSError *error) {
            [self.loadingViewAtStarButton stopAnimating];
            
            if (success) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"UnStar Success", nil)];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"UnStar Failure", nil)];
            }
            
            [self updateStarStateWithRepoName:repoName];
        }];
    } else {
        [[MLGMWebService sharedInstance] starRepo:currentRepo.name completion:^(BOOL success, NSString *repoName, NSError *error) {
            if (success) {
                [self.loadingViewAtStarButton stopAnimating];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Star Success", nil)];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Star Failure", nil)];
            }
            
            [self updateStarStateWithRepoName:repoName];
        }];
    }
}

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

- (void)onClickedForkButton {
    if (self.loadingViewAtForkButton.isAnimating) {
        return;
    }
    
    [self.loadingViewAtForkButton startAnimating];
    [self.forkButton setTitle:@"" forState:UIControlStateNormal];
    
    MLGMRepo *currentRepo = self.repos[self.currentRepoIndex];
    __weak typeof(self) weakSelf = self;
    [[MLGMWebService sharedInstance] forkRepo:currentRepo.name completion:^(BOOL success, NSString *repoName, NSError *error) {
        [weakSelf.loadingViewAtForkButton stopAnimating];
        [weakSelf.forkButton setTitle:NSLocalizedString(@"Fork", nil) forState:UIControlStateNormal];
        
        if (success) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Fork Success", nil)];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Fork Failure", nil)];
        }
    }];
}

- (void)onClickedSkipButton {
    self.currentRepoIndex++;
    
    [self updateViews];
    
    if  (kRecommendationDebug) {
        DDLogInfo(@"self.repos.count = %lu, currentIndex = %lu, didReachEnd = %d", self.repos.count, self.currentRepoIndex, self.didRequestedDataReachEnd);
    }
    
    if (self.currentRepoIndex == self.repos.count && !self.didRequestedDataReachEnd) {
        self.requestPageNumber++;
        
        [self fetchDataAndUpdateViews];
    }
}

- (void)presentAddNewGenePage {
    MLGMNewGeneViewController *vcGenes = [[MLGMNewGeneViewController alloc] init];
    __weak typeof(self) wSelf = self;
    vcGenes.dismissBlock = ^{
        [wSelf fetchDataAndUpdateViews];
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

#pragma mark- Private Method

#pragma mark- Getter Setter
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((kToolBarButtonWidth + kVerticalSeparatorLineWidth) * index - 1, 0, kToolBarButtonWidth + 2, 44);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x6aa9ff)] forState:UIControlStateDisabled];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
