//
//  MLGMTabBarController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMTabBarController.h"

@interface MLGMTabBarController ()
@property (nonatomic, strong) UIButton *centralButton;
@end

@implementation MLGMTabBarController

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

- (void)setTabBarHidden:(BOOL)hidden {
    self.tabBar.hidden = hidden;
    _centralButton.hidden = hidden;
}

#pragma mark - Action
- (void)onClickedCentralButton {
    BLOCK_SAFE_RUN(_centralButtonAction);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
