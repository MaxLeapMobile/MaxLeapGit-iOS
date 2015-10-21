//
//  GMRepoCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMRepoCell.h"


@interface MLGMRepoCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *ownerLabel;

@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation MLGMRepoCell

#pragma mark - init Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.ownerLabel];
    
    return self;
}

#pragma mark- View Life Cycle

#pragma mark- Override Parent Methods
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_avatarImageView, _titleLabel, _descriptionLabel, _ownerLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_avatarImageView(40)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_avatarImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_titleLabel]-8-[_descriptionLabel]-8-[_ownerLabel]-8-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_avatarImageView(40)]-8-[_titleLabel]-8-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_avatarImageView(40)]-8-[_descriptionLabel]-8-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_avatarImageView(40)]-8-[_ownerLabel]-8-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}
#pragma mark- SubViews Configuration

#pragma mark- Actions

#pragma mark- Public Methods
- (void)configureCell:(MLGMRepo *)repo {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:repo.avatarUrl]];
    NSArray *subStrings = [repo.name componentsSeparatedByString:@"/"];
    self.titleLabel.text = [subStrings lastObject];
    self.descriptionLabel.text = repo.introduction;
    self.ownerLabel.text = [NSString stringWithFormat:@"Built by %@", repo.author];
    [self updateConstraints];
}

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark- Getter Setter
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView autoLayoutView];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.clipsToBounds = YES;
    }
    
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel autoLayoutView];
        _titleLabel.font = [UIFont systemFontOfSize:19];
    }
    
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel autoLayoutView];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont systemFontOfSize:15];
        _descriptionLabel.textColor = UIColorFromRGB(0x717175);
    }
    
    return _descriptionLabel;
}

- (UILabel *)ownerLabel {
    if (!_ownerLabel) {
        _ownerLabel = [UILabel autoLayoutView];
        _ownerLabel.font = [UIFont systemFontOfSize:12];
        _ownerLabel.textColor = UIColorFromRGB(0xBFBFBF);
    }
    
    return _ownerLabel;
}
#pragma mark- Helper Method

#pragma mark Temporary Area

@end
