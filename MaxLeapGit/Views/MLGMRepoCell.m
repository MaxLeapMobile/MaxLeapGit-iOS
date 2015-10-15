//
//  GMRepoCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMRepoCell.h"
#import "MLGMRepo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MLGMRepoCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *ownerLabel;

@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation MLGMRepoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureUI];
    }
    return self;
}


- (void)configureUI {
    _icon = [[UIImageView alloc] init];
    _icon.translatesAutoresizingMaskIntoConstraints = NO;
    _icon.layer.cornerRadius = 20;
    _icon.clipsToBounds = YES;
    [self.contentView addSubview:_icon];
   
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:19];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.font = [UIFont systemFontOfSize:15];
    _descriptionLabel.textColor = UIColorFromRGB(0x717175);
    [self.contentView addSubview:_descriptionLabel];
    
    _ownerLabel = [[UILabel alloc] init];
    _ownerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _ownerLabel.font = [UIFont systemFontOfSize:12];
    _ownerLabel.textColor = UIColorFromRGB(0xBFBFBF);
    [self.contentView addSubview:_ownerLabel];
    
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_icon, _titleLabel, _descriptionLabel, _ownerLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_icon(40)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_icon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_titleLabel]-8-[_descriptionLabel]-8-[_ownerLabel]-8-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_icon(40)]-8-[_titleLabel]-8-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_icon(40)]-8-[_descriptionLabel]-8-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_icon(40)]-8-[_ownerLabel]-8-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)updateData:(MLGMRepo *)repo {
    [_icon sd_setImageWithURL:[NSURL URLWithString:repo.avatarUrl]];
    
    NSArray *subStrings = [repo.name componentsSeparatedByString:@"/"];
    _titleLabel.text = [subStrings lastObject];
    _descriptionLabel.text = repo.introduction;
    _ownerLabel.text = [NSString stringWithFormat:@"Built by %@", repo.author];

    _didSetUpConstraints = NO;
    [self updateConstraints];
}

@end
