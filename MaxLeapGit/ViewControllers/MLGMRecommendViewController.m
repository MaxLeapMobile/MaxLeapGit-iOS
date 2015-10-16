//
//  GMRecommendViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMRecommendViewController.h"
#import "MLGMSearchViewController.h"
#import "MLGMNavigationController.h"
#import <WebKit/WebKit.h>
#import "MLGMRecommendEmptyView.h"
#import "MLGMAddNewGeneViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define kVerticalSeparatorLineWidth         1
#define kToolBarButtonCount                 3
#define kToolBarButtonWidth                 (self.view.bounds.size.width - kVerticalSeparatorLineWidth) / kToolBarButtonCount

@interface MLGMRecommendViewController () <WKNavigationDelegate>
@property (nonatomic, strong) NSString *repoName;//e.g. AFNetworking/AFNetworking

@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *forkButton;
@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation MLGMRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"AFNetworking";
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
}

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
    
    _skipButton = [self createButtonAtIndex:2 withTitle:NSLocalizedString(@"Skip", @"") action:@selector(onClickedSkipButton)];
    [toolbarView addSubview:_skipButton];
}

- (UIButton *)createButtonAtIndex:(NSUInteger)index withTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((kToolBarButtonWidth + kVerticalSeparatorLineWidth) * index - 1, 0, kToolBarButtonWidth + 2, 44);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorWithRGBA(106, 169, 255, 1)] forState:UIControlStateDisabled];
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
    MLGMAddNewGeneViewController *vcGenes = [[MLGMAddNewGeneViewController alloc] init];
    UINavigationController *nav = [[MLGMNavigationController alloc] initWithRootViewController:vcGenes];
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
    UINavigationController *nav = [[MLGMNavigationController alloc] initWithRootViewController:vcSearch];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)onClickedStarButton {
    [[MLGMWebService sharedInstance] starRepo:@"AFNetworking/AFNetworking" completion:^(BOOL success, NSString *repoName, NSError *error) {
        if (success && !error) {
            [SVProgressHUD showSuccessWithStatus:@"Succeeded"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
    }];
}

- (void)onClickedForkButton {
    [[MLGMWebService sharedInstance] forkRepo:@"AFNetworking/AFNetworking" completion:^(BOOL success, NSString *repoName, NSError *error) {
        if (success && !error) {
            [SVProgressHUD showSuccessWithStatus:@"Succeeded"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
    }];
}

- (void)onClickedSkipButton {
    //temp -- skip to show empty view
    self.webView.hidden = YES;
    [self showEmptyView];
}

@end
