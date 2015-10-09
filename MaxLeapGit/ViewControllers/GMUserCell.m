//
//  GMUserCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "GMUserCell.h"

@interface GMUserCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;

@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation GMUserCell
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
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_nameLabel];
    
    _updateTimeLabel = [[UILabel alloc] init];
    _updateTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_updateTimeLabel];
    
    [self updateData];
    [self updateConstraintsIfNeeded];
}

- (void)updateData {
    _icon.layer.borderWidth = 1;
    _icon.layer.borderColor = [UIColor grayColor].CGColor;//temp
    
    _nameLabel.text = @"Name";
    _updateTimeLabel.text = @"1 hour ago";
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_icon, _nameLabel, _updateTimeLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_icon(40)]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_nameLabel]-5-[_updateTimeLabel]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(50)]-10-[_nameLabel]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(50)]-10-[_updateTimeLabel]-10-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}

@end
