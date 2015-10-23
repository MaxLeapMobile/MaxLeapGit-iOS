//
//  ViewController.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/9/22.
//  Copyright (c) 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMLoginViewController.h"

@interface MLGMLoginViewController () <MLGMAuthViewControllerDelegate>
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, assign) BOOL isSetupConstraints;
@end

@implementation MLGMLoginViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureSubViews];
    [self updateViewConstraints];
}

#pragma mark- SubViews Configuration
- (void)configureSubViews {
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.loginButton];
}

#pragma mark- Action
- (void)loginButtonPressed:(id)sender {
    [self presentAuthViewController];
}

#pragma mark- Public Method
- (void)presentAuthViewController {
    MLGMAuthViewController *authVC = [MLGMAuthViewController new];
    authVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:authVC];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark- Private Method

#pragma mark- Delegate，DataSource, Callback Method
- (void)authViewController:(MLGMAuthViewController *)authViewController didReceiveAccessToken:(NSString *)accessToken {
    if (!accessToken.length) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
        return;
    }
    
    MLGMAccount *account = [MLGMAccount MR_findFirstOrCreateByAttribute:@"accessToken" withValue:accessToken];
    account.isOnline = @(YES);
    account.accessToken = accessToken;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Logging in", nil)];
    [[MLGMAccountManager sharedInstance] updateAccountProfileToDBCompletion:^(MLGMAccount *account, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"Error"];
            account.isOnline = @(NO);
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        } else {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark- Override Parent Method
- (void)updateViewConstraints {
    if (!self.isSetupConstraints) {
        
        CGFloat topMargin = (self.view.bounds.size.height - 100 - 50 - 40 - 50 - 29) / 2;
        
        [self.logoImageView pinToSuperviewEdges:JRTViewPinTopEdge inset:topMargin];
        [self.logoImageView centerInContainerOnAxis:NSLayoutAttributeCenterX];
        [self.logoImageView constrainToSize:CGSizeMake(100, 100)];
        
        [self.tipsLabel pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.logoImageView withConstant:50];
        [self.tipsLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:(self.view.bounds.size.width - 225) / 2];
        
        [self.loginButton pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.tipsLabel withConstant:50];
        [self.loginButton pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:(self.view.bounds.size.width - 198) / 2];
        
        self.isSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark- Getter Setter
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        UIImage *image = ImageNamed(@"logo");
        _logoImageView = [UIImageView autoLayoutView];
        _logoImageView.image = image;
    }
    
    return _logoImageView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [UILabel autoLayoutView];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.font = [UIFont systemFontOfSize:17];
        _tipsLabel.textColor = UIColorFromRGB(0x808080);
        _tipsLabel.text = NSLocalizedString(@"GitMaster needs permission to access your account", nil);
    }
    
    return _tipsLabel;
}

- (UIButton *)loginButton {
    if  (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_loginButton setTitle:NSLocalizedString(@"Sign in with github", nil) forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitleColor:UIColorFromRGB(0x0076FF) forState:UIControlStateNormal];
    }
    
    return _loginButton;
}

#pragma mark- Helper Method

#pragma mark Temporary Area

@end
