//
//  GMRecommendViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMRecommendViewController.h"


#define kVerticalSeparatorLineWidth         1
#define kToolBarButtonCount                 3
#define kToolBarButtonWidth                 (self.view.bounds.size.width - kVerticalSeparatorLineWidth) / kToolBarButtonCount

@interface MLGMRecommendViewController () <WKNavigationDelegate>
@property (nonatomic, strong) NSMutableArray<MLGMRepo *> *repos;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *forkButton;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingViewAtStarButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingViewAtForkButton;
@end

@implementation MLGMRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
  
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
    
    [self configureToolbarView];
    
    [[MLGMWebService sharedInstance] updateTrendingReposWithCompletion:^(NSArray *repos, NSError *error) {
        NSLog(@"recommended repos = %@", repos);
        
        self.repos = [repos copy];
        [self showRecommendedRepoDetail];
    }];
}

- (void)showRecommendedRepoDetail {
    MLGMRepo *currentRepo = self.repos[self.currentIndex];
    if (currentRepo.htmlPageUrl.length) {
        self.title = currentRepo.name;
        [self.webView stopLoading];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentRepo.htmlPageUrl]]];
    }
}

#pragma mark - Configure SubViews
- (void)configureToolbarView {
    UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64 - 44, self.view.bounds.size.width, 44)];
    toolbarView.backgroundColor = BottomToolBarColor;
    [self.view addSubview:toolbarView];
   
    for (NSUInteger i = 0; i < kToolBarButtonCount; i++) {
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kToolBarButtonWidth + (kToolBarButtonWidth + kVerticalSeparatorLineWidth) * i, (44 - 16) / 2, kVerticalSeparatorLineWidth, 16)];
        separatorLine.backgroundColor = [UIColor whiteColor];
        [toolbarView addSubview:separatorLine];
    }
    
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
}

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

- (void)showEmptyView {
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
        [self.view addSubview:_emptyView];
    }
    _emptyView.hidden = NO;
}

- (void)presentAddNewGenePage {
    MLGMNewGeneViewController *vcGenes = [[MLGMNewGeneViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcGenes];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)replayRecommendationView {
    _emptyView.hidden = YES;
    self.webView.hidden = NO;
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
   
    MLGMRepo *currentRepo = self.repos[self.currentIndex];
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
   
    MLGMRepo *currentRepo = self.repos[self.currentIndex];
    [[MLGMWebService sharedInstance] forkRepo:currentRepo.name completion:^(BOOL success, NSString *repoName, NSError *error) {
        [self.loadingViewAtForkButton stopAnimating];
        [self.forkButton setTitle:NSLocalizedString(@"Fork", nil) forState:UIControlStateNormal];
        
        if (success) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Fork Success", nil)];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Fork Failure", nil)];
        }
    }];
}

- (void)onClickedSkipButton {
    self.currentIndex++;
    [self showRecommendedRepoDetail];
    
    if  (self.currentIndex == self.repos.count - 1) {
        self.webView.hidden = YES;
        [self showEmptyView];
    }
}

@end
