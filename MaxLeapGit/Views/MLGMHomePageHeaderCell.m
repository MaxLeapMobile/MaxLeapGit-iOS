//
//  MLGMUserDetailView.m
//  MaxLeapGit
//
//  Created by julie on 15/10/10.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMHomePageHeaderCell.h"


@interface MLGMHomePageHeaderCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *loginNameLabel;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *followersButton;
@property (nonatomic, strong) UIButton *followingButton;
@property (nonatomic, strong) UIButton *reposButton;
@property (nonatomic, strong) UIButton *starsButton;
@property (nonatomic, strong) UILabel *followerLabel;
@property (nonatomic, strong) UILabel *followingLabel;
@property (nonatomic, strong) UILabel *reposLabel;
@property (nonatomic, strong) UILabel *starsLabel;

@property (nonatomic, strong) UILabel *followerTipsLabel;
@property (nonatomic, strong) UILabel *followingTipsLabel;
@property (nonatomic, strong) UILabel *reposTipsLabel;
@property (nonatomic, strong) UILabel *starsTipsLabel;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MLGMHomePageHeaderCell

#pragma mark - init Method

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }

    [self configureSubViews];
    
    return self;
}

#pragma mark- View Life Cycle

#pragma mark- Override Parent Methods
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    if (!_didSetupConstraints) {
        [self.avatarImageView centerInContainerOnAxis:NSLayoutAttributeCenterX];
        [self.avatarImageView pinToSuperviewEdges:JRTViewPinTopEdge inset:33.0];
        [self.avatarImageView constrainToSize:CGSizeMake(54, 54)];
        
        [self.nickNameLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        [self.nickNameLabel pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.avatarImageView withConstant:8];
        [self.nickNameLabel constrainToHeight:20];
        
        [self.loginNameLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        [self.loginNameLabel pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.nickNameLabel withConstant:2];
        [self.loginNameLabel constrainToHeight:20];
        
        [self.buttonView pinToSuperviewEdges:JRTViewPinBottomEdge | JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        [self.buttonView constrainToHeight:54];
        
        CGFloat buttonWidth = ScreenRect.size.width / 4;
        [self.followersButton constrainToSize:CGSizeMake(buttonWidth, 54)];
        [self.followingButton constrainToSize:CGSizeMake(buttonWidth, 54)];
        [self.reposButton constrainToSize:CGSizeMake(buttonWidth, 54)];
        [self.starsButton constrainToSize:CGSizeMake(buttonWidth, 54)];
        
        [self.followersButton pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinBottomEdge  inset:0.0];
        
        [self.followingButton pinToSuperviewEdges:JRTViewPinLeftEdge inset:buttonWidth];
        [self.followingButton pinToSuperviewEdges:JRTViewPinBottomEdge inset:0.0];
        
        [self.reposButton pinToSuperviewEdges:JRTViewPinBottomEdge inset:0.0];
        [self.reposButton pinToSuperviewEdges:JRTViewPinLeftEdge inset:buttonWidth * 2];

        [self.starsButton pinToSuperviewEdges:JRTViewPinLeftEdge inset:buttonWidth * 3];
        [self.starsButton pinToSuperviewEdges:JRTViewPinBottomEdge inset:0.0f];
        
        [self.followerLabel pinToSuperviewEdges:JRTViewPinTopEdge inset:7];
        [self.followerLabel constrainToHeight:17];
        [self.followerLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge  inset:0.0];
        [self.followerTipsLabel pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.followerLabel withConstant:3];
        [self.followerTipsLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        [self.followerTipsLabel constrainToHeight:14];
        
        [self.followingLabel pinToSuperviewEdges:JRTViewPinTopEdge inset:7];
        [self.followingLabel constrainToHeight:17];
        [self.followingLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge  inset:0.0];
        [self.followingTipsLabel pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.followingLabel withConstant:3];
        [self.followingTipsLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        [self.followingTipsLabel constrainToHeight:14];
        
        [self.reposLabel pinToSuperviewEdges:JRTViewPinTopEdge inset:7];
        [self.reposLabel constrainToHeight:17];
        [self.reposLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge  inset:0.0];
        [self.reposTipsLabel pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.reposLabel withConstant:3];
        [self.reposTipsLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        [self.reposTipsLabel constrainToHeight:14];
        
        [self.starsLabel pinToSuperviewEdges:JRTViewPinTopEdge inset:7];
        [self.starsLabel constrainToHeight:17];
        [self.starsLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge  inset:0.0];
        [self.starsTipsLabel pinAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofItem:self.starsLabel withConstant:3];
        [self.starsTipsLabel pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        [self.starsTipsLabel constrainToHeight:14];
        
        [self.line1 constrainToSize:CGSizeMake(1, 12)];
        [self.line2 constrainToSize:CGSizeMake(1, 12)];
        [self.line3 constrainToSize:CGSizeMake(1, 12)];
        
        [self.line1 pinAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeRight ofItem:self.followersButton];
        [self.line1 pinAttribute:NSLayoutAttributeCenterY toAttribute:NSLayoutAttributeCenterY ofItem:self.followersButton];
        
        [self.line2 pinAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeRight ofItem:self.followingButton];
        [self.line2 pinAttribute:NSLayoutAttributeCenterY toAttribute:NSLayoutAttributeCenterY ofItem:self.followingButton];
        
        [self.line3 pinAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeRight ofItem:self.reposButton];
        [self.line3 pinAttribute:NSLayoutAttributeCenterY toAttribute:NSLayoutAttributeCenterY ofItem:self.reposButton];
        
        _didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark- SubViews Configuration
- (void)configureSubViews {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.loginNameLabel];
    [self.contentView addSubview:self.buttonView];
    
    [self.buttonView addSubview:self.followersButton];
    [self.buttonView addSubview:self.followingButton];
    [self.buttonView addSubview:self.reposButton];
    [self.buttonView addSubview:self.starsButton];
    
    [self.buttonView addSubview:self.line1];
    [self.buttonView addSubview:self.line2];
    [self.buttonView addSubview:self.line3];
    
    [self.followersButton addSubview:self.followerLabel];
    [self.followersButton addSubview:self.followerTipsLabel];
    
    [self.followingButton addSubview:self.followingLabel];
    [self.followingButton addSubview:self.followingTipsLabel];
    
    [self.reposButton addSubview:self.reposLabel];
    [self.reposButton addSubview:self.reposTipsLabel];
    
    [self.starsButton addSubview:self.starsLabel];
    [self.starsButton addSubview:self.starsTipsLabel];
    
    self.backgroundColor = ThemeNavigationBarColor;
}

#pragma mark - Actions
- (void)configureView:(MLGMActorProfile *)actorProfile {
    [self.avatarImageView sd_setImageWithURL:actorProfile.avatarUrl.toURL];
    self.loginNameLabel.text = actorProfile.loginName;
    self.nickNameLabel.text = actorProfile.nickName;

    if (actorProfile.followerCount) {
        self.followerLabel.text = [NSString stringWithFormat:@"%@", actorProfile.followerCount];
    } else {
        self.followerLabel.text = @"-";
    }
    
    if (actorProfile.followingCount) {
        self.followingLabel.text = [NSString stringWithFormat:@"%@", actorProfile.followingCount];
    } else {
        self.followingLabel.text = @"-";
    }
    
    if (actorProfile.publicRepoCount) {
        self.reposLabel.text = [NSString stringWithFormat:@"%@", actorProfile.publicRepoCount];
    } else {
        self.reposLabel.text = @"-";
    }
    
    if (actorProfile.starCount) {
        self.starsLabel.text = [NSString stringWithFormat:@"%@", actorProfile.starCount];
    } else {
        self.starsLabel.text = @"-";
    }
}

- (void)followersButtonPressed:(id)sender {
    BLOCK_SAFE_RUN(_followersButtonAction);
}

- (void)followingButtonPressed:(id)sender {
    BLOCK_SAFE_RUN(_followingButtonAction);
}

- (void)reposButtonPressed:(id)sender {
    BLOCK_SAFE_RUN(_reposButtonAction);
}

- (void)starButtonPressed:(id)sender {
    BLOCK_SAFE_RUN(_starsButtonAction);
}

#pragma mark- Public Methods

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark- Getter Setter
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView autoLayoutView];
        _avatarImageView.layer.cornerRadius = 54 / 2;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.backgroundColor = [UIColor whiteColor];
    }
    
    return _avatarImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel autoLayoutView];
        _nickNameLabel.text = @"Name";
        _nickNameLabel.font = [UIFont systemFontOfSize:17];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.textColor = [UIColor whiteColor];
    }
    
    return _nickNameLabel;
}

- (UILabel *)loginNameLabel {
    if (!_loginNameLabel) {
        _loginNameLabel = [UILabel autoLayoutView];
        _loginNameLabel.text = @"LoginName";
        _loginNameLabel.font = [UIFont systemFontOfSize:15];
        _loginNameLabel.textAlignment = NSTextAlignmentCenter;
        _loginNameLabel.textColor = UIColorFromRGB(0x808080);
    }
    
    return _loginNameLabel;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [UIView autoLayoutView];
        _buttonView.backgroundColor = [UIColor clearColor];
    }
    
    return _buttonView;
}

- (UIButton *)followersButton {
    if (!_followersButton) {
        _followersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followersButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_followersButton setBackgroundColor:[UIColor clearColor]];
        [_followersButton addTarget:self action:@selector(followersButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _followersButton;
}

- (UIButton *)followingButton {
    if (!_followingButton) {
        _followingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followingButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_followingButton setBackgroundColor:[UIColor clearColor]];
        [_followingButton addTarget:self action:@selector(followingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _followingButton;
}

- (UIButton *)reposButton {
    if (!_reposButton) {
        _reposButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reposButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_reposButton setBackgroundColor:[UIColor clearColor]];
        [_reposButton addTarget:self action:@selector(reposButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _reposButton;
}

- (UIButton *)starsButton {
    if (!_starsButton) {
        _starsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _starsButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_starsButton setBackgroundColor:[UIColor clearColor]];
        [_starsButton addTarget:self action:@selector(starButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _starsButton;
}

- (UILabel *)followerLabel {
    if (!_followerLabel) {
        _followerLabel = [UILabel autoLayoutView];
        _followerLabel.font = [UIFont systemFontOfSize:17];
        _followerLabel.textColor = [UIColor whiteColor];
        _followerLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _followerLabel;
}

- (UILabel *)followingLabel {
    if (!_followingLabel) {
        _followingLabel = [UILabel autoLayoutView];
        _followingLabel.font = [UIFont systemFontOfSize:17];
        _followingLabel.textColor = [UIColor whiteColor];
        _followingLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _followingLabel;
}

- (UILabel *)reposLabel {
    if (!_reposLabel) {
        _reposLabel = [UILabel autoLayoutView];
        _reposLabel.font = [UIFont systemFontOfSize:17];
        _reposLabel.textColor = [UIColor whiteColor];
        _reposLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _reposLabel;
}

- (UILabel *)starsLabel {
    if (!_starsLabel) {
        _starsLabel = [UILabel autoLayoutView];
        _starsLabel.font = [UIFont systemFontOfSize:17];
        _starsLabel.textColor = [UIColor whiteColor];
        _starsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _starsLabel;
}

- (UILabel *)followerTipsLabel {
    if (!_followerTipsLabel) {
        _followerTipsLabel = [UILabel autoLayoutView];
        _followerTipsLabel.font = [UIFont systemFontOfSize:13];
        _followerTipsLabel.textColor = [UIColor whiteColor];
        _followerTipsLabel.text = NSLocalizedString(@"Followers", nil);
        _followerTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _followerTipsLabel;
}

- (UILabel *)followingTipsLabel {
    if (!_followingTipsLabel) {
        _followingTipsLabel = [UILabel autoLayoutView];
        _followingTipsLabel.text = NSLocalizedString(@"Following", nil);
        _followingTipsLabel.font = [UIFont systemFontOfSize:13];
        _followingTipsLabel.textColor = [UIColor whiteColor];
        _followingTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _followingTipsLabel;
}

- (UILabel *)reposTipsLabel {
    if (!_reposTipsLabel) {
        _reposTipsLabel = [UILabel autoLayoutView];
        _reposTipsLabel.text = NSLocalizedString(@"Repo", nil);
        _reposTipsLabel.font = [UIFont systemFontOfSize:13];
        _reposTipsLabel.textColor = [UIColor whiteColor];
        _reposTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _reposTipsLabel;
}

- (UILabel *)starsTipsLabel {
    if (!_starsTipsLabel) {
        _starsTipsLabel = [UILabel autoLayoutView];
        _starsTipsLabel.text = NSLocalizedString(@"Star", nil);
        _starsTipsLabel.font = [UIFont systemFontOfSize:13];
        _starsTipsLabel.textColor = [UIColor whiteColor];
        _starsTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _starsTipsLabel;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [UIView autoLayoutView];
        _line1.backgroundColor = [UIColor whiteColor];
    }
    
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [UIView autoLayoutView];
        _line2.backgroundColor = [UIColor whiteColor];
    }
    
    return _line2;
}

- (UIView *)line3 {
    if (!_line3) {
        _line3 = [UIView autoLayoutView];
        _line3.backgroundColor = [UIColor whiteColor];
    }
    
    return _line3;
}

#pragma mark- Helper Method

#pragma mark Temporary Area
@end
