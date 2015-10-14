//
//  GMUserCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMUserCell.h"

@interface MLGMUserCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;

@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation MLGMUserCell
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
    [self.contentView addSubview:_icon];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.font = [UIFont systemFontOfSize:19];
    [self.contentView addSubview:_nameLabel];
    
    _updateTimeLabel = [[UILabel alloc] init];
    _updateTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _updateTimeLabel.font = [UIFont systemFontOfSize:12];
    _updateTimeLabel.textColor = UIColorFromRGB(0xBFBFBF);
    [self.contentView addSubview:_updateTimeLabel];
    
    [self updateData];
    [self updateConstraintsIfNeeded];
}

- (void)updateData {
    _icon.backgroundColor = [UIColor lightGrayColor];
    
    _nameLabel.text = @"Name";
    _updateTimeLabel.text = @"Last Updated at: 13:24";
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_icon, _nameLabel, _updateTimeLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_icon(40)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_icon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_nameLabel]-8-[_updateTimeLabel]-8-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_icon(40)]-8-[_nameLabel]-8-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_icon(40)]-8-[_updateTimeLabel]-8-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
        
        [super updateConstraints];
    }
}

@end
