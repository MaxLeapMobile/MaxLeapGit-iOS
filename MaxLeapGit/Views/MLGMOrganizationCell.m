//
//  MLGMOrganizationCell.m
//  MaxLeapGit
//
//  Created by Li Zhu on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMOrganizationCell.h"

@interface MLGMOrganizationCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, assign) BOOL didSetUpConstraints;
@property (nonatomic, strong) MLGMActorProfile *organizationProfile;
@end

@implementation MLGMOrganizationCell

#pragma mark - init Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.updateTimeLabel];
    
    return self;
}
#pragma mark- View Life Cycle


#pragma mark- Override Parent Methods
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_avatarImageView, _nameLabel, _updateTimeLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_avatarImageView(40)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_nameLabel]-8-[_updateTimeLabel]-8-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_avatarImageView(40)]-8-[_nameLabel]-8-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_avatarImageView(40)]-8-[_updateTimeLabel]-8-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark- SubViews Configuration

#pragma mark- Actions

#pragma mark- Public Methods
- (void)configureCell:(MLGMActorProfile *)actorProfile {
    self.organizationProfile = actorProfile;
    
    [self.avatarImageView sd_setImageWithURL:actorProfile.avatarUrl.toURL];
    self.nameLabel.text = actorProfile.loginName;
    
    if (actorProfile.githubUpdateTime) {
        NSString *updateAtString = [NSString stringWithFormat:@"Last Update at %@", [actorProfile.githubUpdateTime timeAgo]];
        self.updateTimeLabel.text = updateAtString;
    } else {
        [kWebService fetchOrganizationUpdateDateForOrgName:self.organizationProfile.loginName completion:^(NSDate *updatedAt, NSString *orgName, NSError *error) {
            MLGMActorProfile *latestProfile = [MLGMActorProfile MR_findFirstByAttribute:@"loginName" withValue:self.organizationProfile.loginName];
            if (latestProfile.githubUpdateTime) {
                NSString *updateAtString = [NSString stringWithFormat:@"Last Update at %@", [latestProfile.githubUpdateTime timeAgo]];
                self.updateTimeLabel.text = updateAtString;
            }
        }];
    }
}

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark- Getter Setter
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
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

#pragma mark- Helper Method

#pragma mark Temporary Area

@end

