//
//  MLGMFollowUserCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMFollowUserCell.h"

@interface MLGMFollowUserCell ()
@property (nonatomic, strong) UIButton *followButton;
@end

@implementation MLGMFollowUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configureFollowButton];
    }
    return self;
}

- (void)configureFollowButton {
    _followButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _followButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_followButton setTitle:NSLocalizedString(@"Follow", @"") forState:UIControlStateNormal];
    _followButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _followButton.layer.borderWidth = 1;
    [_followButton addTarget:self action:@selector(onClickedFollowButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_followButton);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_followButton(82)]-8-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_followButton(28)]" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_followButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

#pragma mark - Action
- (void)onClickedFollowButton {
    BLOCK_SAFE_RUN(_followAction);
}

@end
