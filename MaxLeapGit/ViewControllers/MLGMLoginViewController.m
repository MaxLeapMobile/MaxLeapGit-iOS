//
//  ViewController.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/9/22.
//  Copyright (c) 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMLoginViewController.h"
#import "MLGMAuthViewController.h"
#import "MLGMWebService.h"
#import "MLGMAccount.h"
#import "MLGMAccount.h"
#import "MLGMActorProfile.h"

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
    return;
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
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        MLGMAccount *account = [MLGMAccount MR_findFirstOrCreateByAttribute:@"accessToken" withValue:accessToken inContext:localContext];
        account.isOnline = @(YES);
        account.accessToken = accessToken;
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (error && !contextDidSave) {
            DDLogError(@"save accessToken failure:%@", error.localizedDescription);
        }
    }];
}

#pragma mark- Override Parent Method
- (void)updateViewConstraints {
    if (!self.isSetupConstraints) {
        
        
        [self.logoImageView pinToSuperviewEdges:JRTViewPinTopEdge inset:136.0f];
        [self.logoImageView centerInContainerOnAxis:NSLayoutAttributeCenterX];
        [self.logoImageView constrainToSize:CGSizeMake(100, 100)];
        
        [self.tipsLabel pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.logoImageView withConstant:50];
        [self.tipsLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:68];
        
        [self.loginButton pinToSuperviewEdges:JRTViewPinBottomEdge inset:160];
        [self.loginButton pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:68];
        
        self.isSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark- Getter Setter
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        UIImage *image = ImageNamed(@"placehold");
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
        _tipsLabel.text = NSLocalizedString(@"GitMaster needs permission to access your account", nil);
        _tipsLabel.textColor = UIColorFromRGB(0x000000);
    }
    
    return _tipsLabel;
}

- (UIButton *)loginButton {
    if  (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_loginButton setTitle:NSLocalizedString(@"Sign in with github", nil) forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitleColor:UIColorFromRGB(0x0000ff) forState:UIControlStateNormal];
    }
    
    return _loginButton;
}

#pragma mark- Helper Method

#pragma mark Temporary Area

@end
