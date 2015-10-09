//
//  GMTimeLineCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "GMTimeLineCell.h"

@interface GMTimeLineCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *messageLabel; //optional
@property (nonatomic, strong) UILabel *updateTimeLabel;

@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation GMTimeLineCell
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
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descriptionLabel.numberOfLines = 0;
    [self.contentView addSubview:_descriptionLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_messageLabel];
    
    _updateTimeLabel = [[UILabel alloc] init];
    _updateTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_updateTimeLabel];
    
    [self updateData];
    [self updateConstraintsIfNeeded];
}

- (void)updateData {
    _icon.layer.borderWidth = 1;
    _icon.layer.borderColor = [UIColor grayColor].CGColor;//temp
    
    _descriptionLabel.text = @"** pushed to master at ********";
    _messageLabel.text = @"update";
    _updateTimeLabel.text = @"1 hour ago";
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_icon, _descriptionLabel, _messageLabel, _updateTimeLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_icon(50)]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_descriptionLabel]-10-[_messageLabel]-10-[_updateTimeLabel]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(50)]-10-[_descriptionLabel]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(50)]-10-[_messageLabel]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(50)]-10-[_updateTimeLabel]-10-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}

@end
