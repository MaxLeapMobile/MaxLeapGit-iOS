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
    [_followButton setTitle:NSLocalizedString(@"Follow", @"") forState:UIControlStateNormal];
    _followButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _followButton.layer.borderWidth = 1;
    _followButton.frame = CGRectMake(self.contentView.bounds.size.width - 110, 20, 100, 30);
    _followButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview:_followButton];
}

@end
