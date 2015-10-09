//
//  GMIntroductionViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMIntroductionViewController.h"
#import "MLGMLoginViewController.h"
#import "AppDelegate.h"

@interface MLGMIntroductionViewController ()
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *signInButton;
@end

@implementation MLGMIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureUI];
}

- (void)configureUI {
    _logo = [[UIImageView alloc] init];
    _logo.translatesAutoresizingMaskIntoConstraints = NO;
    _logo.layer.borderColor = [UIColor grayColor].CGColor;
    _logo.layer.borderWidth = 1;
    [self.view addSubview:_logo];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.numberOfLines = 0;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.text = NSLocalizedString(@"GitMaster needs permission to access your account", @"");
    [self.view addSubview:_textLabel];
    
    _signInButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _signInButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_signInButton setTitle:NSLocalizedString(@"Sign in with GitHub", @"") forState:UIControlStateNormal];
    [_signInButton addTarget:self action:@selector(signInWithGitHub) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signInButton];
    
    [self updateConstraints];
}

- (void)updateConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_logo, _textLabel, _signInButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[_logo(60)]-20-[_textLabel(60)]-30-[_signInButton(40)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logo attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:300]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_signInButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:240]];
}

#pragma mark - Actions
- (void)signInWithGitHub {
    MLGMLoginViewController *vcLogin = [[MLGMLoginViewController alloc] initWithCompletionBlock:^(BOOL succeeded){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMainViewAfterLogin];
        });
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcLogin];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showMainViewAfterLogin {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.tabBarController];
}

@end
