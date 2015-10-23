//
//  MLGMTabBarController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMCustomTabBarController.h"

@interface MLGMCustomTabBarController () <UITabBarControllerDelegate>
@property (nonatomic, strong) UIButton *recommendationButton;
@property (nonatomic, strong) UINavigationController *firstNav;
@property (nonatomic, strong) UIViewController *secondVC;
@property (nonatomic, strong) UINavigationController *thirdNav;
@property (nonatomic, strong) NSTimer *credentialsMonitor;
@property (nonatomic, assign) BOOL didInitSyncOnlineAccountGenes;
@property (nonatomic, assign) BOOL isViewControllerUsed;
@end

@implementation MLGMCustomTabBarController

#pragma mark - init Method
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.viewControllers = @[self.firstNav, self.secondVC, self.thirdNav];
    
    return self;
}

#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self.tabBar addSubview:self.recommendationButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!kOnlineUserName.length) {
        if (!self.isViewControllerUsed) {
            MLGMLoginViewController *loginVC = [[MLGMLoginViewController alloc] init];
            [self presentViewController:loginVC animated:NO completion:nil];
        } else {
            [self prepareToLogout];
        }
        
        return;
    }
    
    self.isViewControllerUsed = YES;
    
    if (!self.credentialsMonitor.isValid) {
        self.credentialsMonitor = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkCredentials:) userInfo:nil repeats:YES];
        [self.credentialsMonitor fire];
    }
    
    if (!self.didInitSyncOnlineAccountGenes) {
        [self setupThirdTabName];
        [KSharedWebService syncOnlineAccountProfileToMaxLeapCompletion:nil];
        [KSharedWebService initializeGenesFromGitHubAndMaxLeapToLocalDBComletion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [KSharedWebService syncOnlineAccountGenesToMaxLeapCompletion:nil];
                self.didInitSyncOnlineAccountGenes = YES;
            }
        }];
    }
}

#pragma mark- Override Parent Methods

#pragma mark- SubViews Configuration

- (void)setupThirdTabName {
    UIViewController *homePageViewController = (MLGMHomePageViewController *)self.thirdNav.topViewController;
    if ([homePageViewController isKindOfClass:[MLGMHomePageViewController class]]) {
        [(MLGMHomePageViewController *)homePageViewController setOwnerName:kOnlineUserName];
    }
}

#pragma mark- Actions
#pragma mark- Public Methods
- (void)setTabBarHidden:(BOOL)hidden {
    self.tabBar.hidden = hidden;
    self.recommendationButton.hidden = hidden;
}

#pragma mark- Private Methods
- (void)presentRecommendationViewController {
    UIViewController *vcRecommend = [[MLGMRecommendViewController alloc] init];
    UINavigationController *navRecommend = [[UINavigationController alloc] initWithRootViewController:vcRecommend];
    navRecommend.navigationBar.barStyle = UIBarStyleBlack;
    navRecommend.title = vcRecommend.title = NSLocalizedString(@"Recommend", @"");
    [self presentViewController:navRecommend animated:YES completion:nil];
}

- (void)checkCredentials:(id)sender {
    [KSharedWebService checkSessionTokenStatusCompletion:^(BOOL valid, NSError *error) {
        if (!valid && kOnlineUserName.length > 0) {
            [self prepareToLogout];
        }
    }];
}

- (void)prepareToLogout {
    [KSharedWebService cancelAllDataTasksCompletion:^{
        [self.credentialsMonitor invalidate];
        self.credentialsMonitor = nil;
        
        [kOnlineAccount MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate logout];
    }];
}

#pragma mark- Delegate，DataSource, Callback Method
#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.secondVC) {
        [self presentRecommendationViewController];
        return NO;
    }
    
    return YES;
}

#pragma mark- Getter Setter
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

- (UIButton *)recommendationButton {
    if (!_recommendationButton) {
        CGFloat buttonWidth = ScreenRect.size.width / 3;
        _recommendationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recommendationButton.frame = CGRectMake((ScreenRect.size.width - buttonWidth) / 2, 0, buttonWidth, self.tabBar.bounds.size.height);
        [_recommendationButton setImage:[UIImage imageNamed:@"star_icon_normal"] forState:UIControlStateNormal];
        [_recommendationButton setImage:[UIImage imageNamed:@"star_icon_selected"] forState:UIControlStateHighlighted];
    }
    
    return _recommendationButton;
}

#pragma mark- Helper Method

#pragma mark Temporary Area

@end
