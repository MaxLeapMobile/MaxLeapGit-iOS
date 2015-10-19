//
//  MLGMTabBarController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMCustomTabBarController.h"
#import "MLGMTimeLineViewController.h"
#import "MLGMRecommendViewController.h"
#import "MLGMHomePageViewController.h"
#import "MLGMLoginViewController.h"

@interface MLGMCustomTabBarController () <UITabBarControllerDelegate>
@property (nonatomic, strong) UIButton *centralButton;
@property (nonatomic, strong) UINavigationController *firstNav;
@property (nonatomic, strong) UIViewController *secondVC;
@property (nonatomic, strong) UINavigationController *thirdNav;
@end

@implementation MLGMCustomTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        __weak typeof(self) wSelf = self;
        self.centralButtonAction = ^{
            UIViewController *vcRecommend = [[MLGMRecommendViewController alloc] init];
            UINavigationController *navRecommend = [[UINavigationController alloc] initWithRootViewController:vcRecommend];
            navRecommend.title = vcRecommend.title = NSLocalizedString(@"Recommend", @"");
            [wSelf presentViewController:navRecommend animated:YES completion:nil];
        };
        self.viewControllers = @[self.firstNav, self.secondVC, self.thirdNav];
//        self.delegate = self;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentLoginVCIfNeeded];
    UIViewController *homePageViewController = (MLGMHomePageViewController *)self.thirdNav.topViewController;
    if ([homePageViewController isKindOfClass:[MLGMHomePageViewController class]]) {
        [(MLGMHomePageViewController *)homePageViewController setOwnerName:kOnlineUserName];
    }
}

- (void)configureUI {
    CGFloat buttonWidth = self.view.bounds.size.width / 3;
    _centralButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centralButton setImage:[UIImage imageNamed:@"star_icon_normal"] forState:UIControlStateNormal];
    [_centralButton setImage:[UIImage imageNamed:@"star_icon_selected"] forState:UIControlStateHighlighted];
    _centralButton.frame = CGRectMake(buttonWidth, self.view.bounds.size.height - self.tabBar.bounds.size.height, buttonWidth, self.tabBar.bounds.size.height);
    [_centralButton addTarget:self action:@selector(onClickedCentralButton) forControlEvents:UIControlEventTouchUpInside];
    _centralButton.tag = 1001;
    [self.view addSubview:_centralButton];
}

- (void)setTabBarHidden:(BOOL)hidden {
    self.tabBar.hidden = hidden;
    _centralButton.hidden = hidden;
}

#pragma mark - Action
- (void)onClickedCentralButton {
    kOnlineAccount.isOnline = @NO;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    //    [self presentLoginVCIfNeeded];
    
    BLOCK_SAFE_RUN(_centralButtonAction);
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIViewController *centralViewController = self.viewControllers[1];
    if (centralViewController == viewController) {
        return NO;
    }
    return YES;
}

- (void)presentLoginVCIfNeeded {
    if (!kOnlineUserName.length) {
        MLGMLoginViewController *loginVC = [[MLGMLoginViewController alloc] init];
        [self presentViewController:loginVC animated:NO completion:nil];
    }
}

- (UINavigationController *)firstNav {
    if (!_firstNav) {
        UIViewController *firstVC = [[MLGMTimeLineViewController alloc] init];
        _firstNav = [[UINavigationController alloc] initWithRootViewController:firstVC];
        _firstNav.navigationBar.barStyle = UIBarStyleBlack;
        _firstNav.title = firstVC.title = NSLocalizedString(@"TimeLine", @"");
        [_firstNav.tabBarItem setImage:ImageNamed(@"timeline_icon_normal")];
        [_firstNav.tabBarItem setSelectedImage:ImageNamed(@"timeline_icon_selected")];
    }
    
    return _firstNav;
}

- (UIViewController *)secondVC {
    if (!_secondVC) {
        _secondVC = [[UIViewController alloc] init];
    }
    
    return _secondVC;
}

- (UINavigationController *)thirdNav {
    if (!_thirdNav) {
        MLGMHomePageViewController *thirdVC = [[MLGMHomePageViewController alloc] init];
        _thirdNav = [[UINavigationController alloc] initWithRootViewController:thirdVC];
        _thirdNav.navigationBar.barStyle = UIBarStyleBlack;
        _thirdNav.title = thirdVC.title = NSLocalizedString(@"Mine", @"");
        [_thirdNav.tabBarItem setImage:ImageNamed(@"mine_icon_normal")];
        [_thirdNav.tabBarItem setSelectedImage:ImageNamed(@"mine_icon_selected")];
    }
    
    return _thirdNav;
}

@end
