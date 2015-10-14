//
//  MLGMTabBarController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMTabBarController.h"
#import "MLGMTimeLineViewController.h"
#import "MLGMRecommendViewController.h"
#import "MLGMUserPageViewController.h"
#import "MLGMNavigationController.h"
#import "MLGMLoginViewController.h"

@interface MLGMTabBarController () <UITabBarControllerDelegate>
@property (nonatomic, strong) UIButton *centralButton;
@end

@implementation MLGMTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        __weak typeof(self) wSelf = self;
        self.centralButtonAction = ^{
            UIViewController *vcRecommend = [[MLGMRecommendViewController alloc] init];
            UINavigationController *navRecommend = [[MLGMNavigationController alloc] initWithRootViewController:vcRecommend];
            navRecommend.title = vcRecommend.title = NSLocalizedString(@"Recommend", @"");
            [wSelf presentViewController:navRecommend animated:YES completion:nil];
        };
        
        UIViewController *vc1 = [[MLGMTimeLineViewController alloc] init];
        UINavigationController *nav1 = [[MLGMNavigationController alloc] initWithRootViewController:vc1];
        nav1.title = vc1.title = NSLocalizedString(@"TimeLine", @"");
        [nav1.tabBarItem setImage:ImageNamed(@"timeline_icon_normal")];
        [nav1.tabBarItem setSelectedImage:ImageNamed(@"timeline_icon_selected")];
        
        UIViewController *vc2 = [[UIViewController alloc] init];
        
        UIViewController *vc3 = [[MLGMUserPageViewController alloc] init];
        UINavigationController *nav3 = [[MLGMNavigationController alloc] initWithRootViewController:vc3];
        nav3.title = vc3.title = NSLocalizedString(@"Mine", @"");
        [vc3.tabBarItem setImage:ImageNamed(@"mine_icon_normal")];
        [vc3.tabBarItem setSelectedImage:ImageNamed(@"mine_icon_selected")];
        
        self.viewControllers = @[nav1, vc2, nav3];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self configureUI];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentLoginVCIfNeeded];
}

- (void)setTabBarHidden:(BOOL)hidden {
    self.tabBar.hidden = hidden;
    _centralButton.hidden = hidden;
}

#pragma mark - Action
- (void)onClickedCentralButton {
    kOnlineAccount.isOnline = @NO;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [self presentLoginVCIfNeeded];
    
//    BLOCK_SAFE_RUN(_centralButtonAction);
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

@end
