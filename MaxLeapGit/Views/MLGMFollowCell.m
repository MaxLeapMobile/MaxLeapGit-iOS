//
//  GMUserCell.m
//  MaxLeapGit
//
//  Created by Julie on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMFollowCell.h"

@interface MLGMFollowCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) UIButton *followSwitchButton;
@property (nonatomic, assign) BOOL didSetUpConstraints;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) MLGMActorProfile *actorProfile;
@property (nonatomic, assign) BOOL isAnimationRunning;
@end

@implementation MLGMFollowCell

#pragma mark - init Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.updateTimeLabel];
    [self.contentView addSubview:self.followSwitchButton];
    [self.followSwitchButton addSubview:self.loadingView];
    
    return self;
}

#pragma mark- Override Parent Methods
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_avatarImageView, _nameLabel, _updateTimeLabel, _followSwitchButton, _loadingView);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_avatarImageView(40)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_nameLabel]-8-[_updateTimeLabel]-8-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_avatarImageView(40)]-8-[_nameLabel]-8-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_avatarImageView(40)]-8-[_updateTimeLabel]-8-|" options:0 metrics:nil views:views]];
       
        if (!self.isForSearchPage) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_followSwitchButton(82)]-8-|" options:0 metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_followSwitchButton(28)]" options:0 metrics:nil views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_followSwitchButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        } else {
            _followSwitchButton.hidden = YES;
        }
        
        [self.loadingView centerInContainer];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark- SubViews Configuration

#pragma mark- Actions
- (void)followSwitchButtonPressed:(id)sender {
    BLOCK_SAFE_ASY_RUN_MainQueue(self.followButtonPressedAction, self.actorProfile.loginName);
}

- (void)startLoadingAnimation {
    [self.loadingView startAnimating];
}

- (void)stopLoadingAnimation {
    [self.loadingView stopAnimating];
}

#pragma mark- Public Methods
- (void)configureCell:(MLGMActorProfile *)actorProfile {
    self.actorProfile = actorProfile;
    [self.avatarImageView sd_setImageWithURL:actorProfile.avatarUrl.toURL];
    self.nameLabel.text = actorProfile.nickName ?: actorProfile.loginName;
    
    self.isAnimationRunning = YES;
    [self updateFollowButtonTitleWithUserName:actorProfile.loginName];
    [kWebService checkFollowStatusForUserName:kOnlineUserName followTargetUserName:actorProfile.loginName completion:^(BOOL isFollow, NSString *targetUserName, NSError *error) {
        self.isAnimationRunning = NO;
        [self updateFollowButtonTitleWithUserName:self.actorProfile.loginName];
    }];
    
    if (actorProfile.githubUpdateTime) {
        NSString *updateAtString = [NSString stringWithFormat:@"Last Update at %@", [actorProfile.githubUpdateTime timeAgo]];
        self.updateTimeLabel.text = updateAtString;
    } else {
        if (actorProfile.loginName.length) {
            self.updateTimeLabel.text = [@"https://github.com/" stringByAppendingString:actorProfile.loginName];
        }
    }
}

#pragma mark- Private Methods

- (void)updateFollowButtonTitleWithUserName:(NSString *)targetLoginName {
    [self.loadingView stopAnimating];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"sourceLoginName = %@ and targetLoginName = %@", kOnlineUserName, targetLoginName];
    MLGMFollowRelation *followRelation = [MLGMFollowRelation MR_findFirstWithPredicate:p];
    if (!followRelation.isFollow) {
        [self.loadingView startAnimating];
        return;
    }
    
    if (followRelation.isFollow.boolValue) {
        [self.followSwitchButton setTitle:NSLocalizedString(@"Unfollow", nil) forState:UIControlStateNormal];
    } else {
        [self.followSwitchButton setTitle:NSLocalizedString(@"Follow", nil) forState:UIControlStateNormal];
    }
}

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark- Getter Setter
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView autoLayoutView];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel autoLayoutView];
        _nameLabel.font = [UIFont systemFontOfSize:19];
    }
    
    return _nameLabel;
}

- (UILabel *)updateTimeLabel {
    if (!_updateTimeLabel) {
        _updateTimeLabel = [UILabel autoLayoutView];
        _updateTimeLabel.font = [UIFont systemFontOfSize:12];
        _updateTimeLabel.textColor = UIColorFromRGB(0xBFBFBF);
    }
    
    return _updateTimeLabel;
}

- (UIButton *)followSwitchButton {
    if (!_followSwitchButton) {
        _followSwitchButton = [UIButton autoLayoutView];
        [_followSwitchButton setTitleColor:UIColorFromRGB(0x474747) forState:UIControlStateNormal];
        _followSwitchButton.layer.borderColor = UIColorFromRGB(0x474747).CGColor;
        _followSwitchButton.layer.borderWidth = 1;
        [_followSwitchButton addTarget:self action:@selector(followSwitchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _followSwitchButton;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [UIActivityIndicatorView autoLayoutView];
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    
    return _loadingView;
}

#pragma mark- Helper Method

#pragma mark Temporary Area

@end

