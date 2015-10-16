//
//  MLGMRepoDetailController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMRepoDetailController.h"
#import <WebKit/WebKit.h>
#import "MLGMTabBarController.h"

#define kVerticalSeparatorLineWidth         1
#define kToolBarButtonCount                 2
#define kToolBarButtonWidth                 (self.view.bounds.size.width - kVerticalSeparatorLineWidth) / kToolBarButtonCount

@interface MLGMRepoDetailController ()
//@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *forkButton;
@end

@implementation MLGMRepoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
	 self.title = self.repoName;
    // Do any additional setup after loading the view.
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
    [self configureToolbarView];
}

- (void)configureToolbarView {
    UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 64 - 44, self.view.bounds.size.width, 44)];
    toolbarView.backgroundColor = BottomToolBarColor;
    [self.view addSubview:toolbarView];
   
    _starButton = [self createButtonAtIndex:0 withTitle:NSLocalizedString(@"Star", @"") action:@selector(onClickedStarButton)];
    [toolbarView addSubview:_starButton];
   
    _forkButton = [self createButtonAtIndex:1 withTitle:NSLocalizedString(@"Fork", @"") action:@selector(onClickedForkButton)];
    [toolbarView addSubview:_forkButton];

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
    
}

- (void)onClickedForkButton {
    
}

@end
