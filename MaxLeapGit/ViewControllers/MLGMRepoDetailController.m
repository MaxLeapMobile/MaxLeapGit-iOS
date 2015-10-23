//
//  MLGMRepoDetailController.m
//  MaxLeapGit
//
//  Created by Li Zhu on 15/10/9.
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
    self.url = [NSString stringWithFormat:@"https://github.com/%@", self.repoName];
    
    [self configureToolbarView];
    [self updateButtonState];
}

- (void)updateButtonState {
    [self updateStarStateWithRepoName:self.repoName];
    [[MLGMAccountManager sharedInstance] checkStarStatusForRepo:self.repoName completion:^(BOOL isStar, NSString *repoName, NSError *error) {
        [self updateStarStateWithRepoName:self.repoName];
    }];
}

- (void)updateStarStateWithRepoName:(NSString *)repoName {
    [self.loadingViewAtStarButton stopAnimating];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"loginName = %@ and repoName = %@", kOnlineUserName, repoName];
    MLGMTagRelation *tagRelation = [MLGMTagRelation MR_findFirstWithPredicate:p];
    if (!tagRelation.isStarred) {
        [self.loadingViewAtStarButton startAnimating];
        return;
    }
    
    if (tagRelation.isStarred.boolValue) {
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
    MLGMTagRelation *tagRelation = [MLGMTagRelation MR_findFirstWithPredicate:p];
    if (tagRelation.isStarred.boolValue) {
        [[MLGMAccountManager sharedInstance] unstarRepo:self.repoName completion:^(BOOL succeeded, NSString *repoName, NSError *error) {
            [self.loadingViewAtStarButton stopAnimating];
            
            if (succeeded) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"UnStar Success", nil)];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"UnStar Failure", nil)];
            }
            
            [self updateStarStateWithRepoName:repoName];
        }];
    } else {
        [[MLGMAccountManager sharedInstance] starRepo:self.repoName completion:^(BOOL succeeded, NSString *repoName, NSError *error) {
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
    
    [[MLGMAccountManager sharedInstance] forkRepo:self.repoName completion:^(BOOL succeeded, NSString *repoName, NSError *error) {
        [self.loadingViewAtForkButton stopAnimating];
        [self.forkButton setTitle:NSLocalizedString(@"Fork", nil) forState:UIControlStateNormal];
        
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Fork Success", nil)];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Fork Failure", nil)];
        }
    }];
}

@end
