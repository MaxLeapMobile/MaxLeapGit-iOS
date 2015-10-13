//
//  GMRepoCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMRepoCell.h"

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
    [self.contentView addSubview:_icon];
   
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descriptionLabel.numberOfLines = 0;
    [self.contentView addSubview:_descriptionLabel];
    
    _ownerLabel = [[UILabel alloc] init];
    _ownerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_ownerLabel];
    
    [self updateData];
    [self updateConstraintsIfNeeded];
}

- (void)updateData {
    _icon.layer.borderWidth = 1;
    _icon.layer.borderColor = [UIColor grayColor].CGColor;//temp
   
    _titleLabel.text = @"GitMaster";
    _descriptionLabel.text = @"GitMaster is ***";
    _ownerLabel.text = @"Built by **";
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_icon, _titleLabel, _descriptionLabel, _ownerLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_icon(50)]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_titleLabel]-10-[_descriptionLabel]-10-[_ownerLabel]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(50)]-10-[_titleLabel]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(50)]-10-[_descriptionLabel]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(50)]-10-[_ownerLabel]-10-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}

@end
