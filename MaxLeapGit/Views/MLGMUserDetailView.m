//
//  MLGMUserDetailView.m
//  MaxLeapGit
//
//  Created by julie on 15/10/10.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMUserDetailView.h"

#define kIconWidthAndHeight                    54

//buttonView
#define kVerticalSeparatorLineWidth            1
#define kHeaderViewButtonCount                 4
#define kHeaderViewButtonWidth                 (self.bounds.size.width - kVerticalSeparatorLineWidth) / kHeaderViewButtonCount

#define kButtonViewHeight                      60
#define kButtonViewSeparatorLineHeight         40

@interface MLGMUserDetailView ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *loginNameLabel;
@end

@implementation MLGMUserDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = ThemeNavigationBarColor;
        
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - kIconWidthAndHeight)/2, 33, kIconWidthAndHeight, kIconWidthAndHeight)];
    _icon.backgroundColor = [UIColor whiteColor];
    [self addSubview:_icon];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33 + kIconWidthAndHeight + 6, self.bounds.size.width, 20)];
    _nameLabel.text = @"Name";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_nameLabel];
    
    _loginNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33 + kIconWidthAndHeight + 26, self.bounds.size.width, 20)];
    _loginNameLabel.text = @"LoginName";
    _loginNameLabel.textAlignment = NSTextAlignmentCenter;
    _loginNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_loginNameLabel];
    
    //configure buttonView on headerView
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kButtonViewHeight, self.bounds.size.width, kButtonViewHeight)];
    buttonView.backgroundColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1];
    [self addSubview:buttonView];
    
    UIButton *followersButton = [self createButtonAtIndex:0 withTitle:@"24\nFollowers" action:@selector(onClickedFollowersButton)];
    [buttonView addSubview:followersButton];
    UIButton *followingButton = [self createButtonAtIndex:1 withTitle:@"12\nFollowing" action:@selector(onClickedFollowingButton)];
    [buttonView addSubview:followingButton];
    UIButton *reposButton = [self createButtonAtIndex:2 withTitle:@"30\nRepos" action:@selector(onClickedReposButton)];
    [buttonView addSubview:reposButton];
    UIButton *starsButton = [self createButtonAtIndex:3 withTitle:@"99\nStars" action:@selector(onClickedStarsButton)];
    [buttonView addSubview:starsButton];
    
    [self addVerticalSeparatorLinesForView:buttonView];
}

- (UIButton *)createButtonAtIndex:(NSUInteger)index withTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((kHeaderViewButtonWidth + kVerticalSeparatorLineWidth) * index, 0, kHeaderViewButtonWidth, kButtonViewHeight);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelOnButton = [[UILabel alloc] initWithFrame:button.bounds];
    labelOnButton.numberOfLines = 0;
    labelOnButton.textColor = [UIColor whiteColor];
    labelOnButton.text = title;
    labelOnButton.textAlignment = NSTextAlignmentCenter;
    [button addSubview:labelOnButton];
    
    return button;
}

- (void)addVerticalSeparatorLinesForView:(UIView *)view {
    for (NSUInteger i = 0; i < kHeaderViewButtonCount; i++) {
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kHeaderViewButtonWidth + (kHeaderViewButtonWidth + kVerticalSeparatorLineWidth) * i, (kButtonViewHeight - kButtonViewSeparatorLineHeight) / 2, kVerticalSeparatorLineWidth, kButtonViewSeparatorLineHeight)];
        separatorLine.backgroundColor = [UIColor whiteColor];
        [view addSubview:separatorLine];
    }
}

#pragma mark - Actions
- (void)onClickedFollowersButton {
    
}

- (void)onClickedFollowingButton {
    
}

- (void)onClickedReposButton {
    
}

- (void)onClickedStarsButton {
    
}

@end
