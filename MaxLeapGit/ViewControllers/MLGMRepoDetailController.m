//
//  MLGMRepoDetailController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMRepoDetailController.h"

#define kVerticalSeparatorLineWidth         1
#define kToolBarButtonCount                 2
#define kToolBarButtonWidth                 (self.view.bounds.size.width - kVerticalSeparatorLineWidth) / kToolBarButtonCount

@interface MLGMRepoDetailController ()
@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *forkButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingViewAtStarButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingViewAtForkButton;
@end

@implementation MLGMRepoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [(MLGMCustomTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
    self.url = [NSString stringWithFormat:@"https://github.com/%@", self.repoName];
    
    [self configureToolbarView];
    [self updateButtonState];
}

- (void)updateButtonState {
    [self updateStarStateWithRepoName:self.repoName];
    [KSharedWebService isStarRepo:self.repoName completion:^(BOOL isStar, NSString *repoName, NSError *error) {
        [self updateStarStateWithRepoName:self.repoName];
    }];
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

- (void)configureToolbarView {
    UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64 - 44, self.view.bounds.size.width, 44)];
    toolbarView.backgroundColor = BottomToolBarColor;
    [self.view addSubview:toolbarView];
    
    _starButton = [self createButtonAtIndex:0 withTitle:NSLocalizedString(@"", @"") action:@selector(onClickedStarButton)];
    [toolbarView addSubview:_starButton];
    
    _loadingViewAtStarButton = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _loadingViewAtStarButton.center = [toolbarView convertPoint:_starButton.center toView:_starButton];
    [_starButton addSubview:_loadingViewAtStarButton];
    
    _forkButton = [self createButtonAtIndex:1 withTitle:NSLocalizedString(@"Fork", @"") action:@selector(onClickedForkButton)];
    [toolbarView addSubview:_forkButton];
    
    _loadingViewAtForkButton = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _loadingViewAtForkButton.center = [toolbarView convertPoint:_forkButton.center toView:_forkButton];
    [_forkButton addSubview:_loadingViewAtForkButton];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kToolBarButtonWidth, (44 - 16) / 2, kVerticalSeparatorLineWidth, 16)];
    separatorLine.backgroundColor = [UIColor whiteColor];
    [toolbarView addSubview:separatorLine];
}

- (UIButton *)createButtonAtIndex:(NSUInteger)index withTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((kToolBarButtonWidth + kVerticalSeparatorLineWidth) * index, 0, kToolBarButtonWidth, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Actions

- (void)onClickedStarButton {
    if (self.loadingViewAtStarButton.isAnimating) {
        return;
    }
    
    [self.starButton setTitle:@"" forState:UIControlStateNormal];
    [self.loadingViewAtStarButton startAnimating];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, self.repoName];
    MLGMStarRelation *starRelation = [MLGMStarRelation MR_findFirstWithPredicate:p];
    if (starRelation.isStar.boolValue) {
        [KSharedWebService unstarRepo:self.repoName completion:^(BOOL success, NSString *repoName, NSError *error) {
            [self.loadingViewAtStarButton stopAnimating];
            
            if (success) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"UnStar Success", nil)];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"UnStar Failure", nil)];
            }
            
            [self updateStarStateWithRepoName:repoName];
        }];
    } else {
        [KSharedWebService starRepo:self.repoName completion:^(BOOL success, NSString *repoName, NSError *error) {
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

- (void)onClickedForkButton {
    if (self.loadingViewAtForkButton.isAnimating) {
        return;
    }
    
    [self.loadingViewAtForkButton startAnimating];
    [self.forkButton setTitle:@"" forState:UIControlStateNormal];
    
    [KSharedWebService forkRepo:self.repoName completion:^(BOOL success, NSString *repoName, NSError *error) {
        [self.loadingViewAtForkButton stopAnimating];
        [self.forkButton setTitle:NSLocalizedString(@"Fork", nil) forState:UIControlStateNormal];
        
        if (success) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Fork Success", nil)];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Fork Failure", nil)];
        }
    }];
}

@end
