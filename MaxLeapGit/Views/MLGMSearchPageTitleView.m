//
//  MLGMSearchPageTitleView.m
//  MaxLeapGit
//
//  Created by Julie on 15/10/14.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMSearchPageTitleView.h"

@interface MLGMSearchPageTitleView ()
@property (nonatomic, strong) UIButton *repoButton;
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIButton *sortButton;

@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation MLGMSearchPageTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    _repoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _repoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_repoButton setTitle:NSLocalizedString(@"Repo", @"") forState:UIControlStateNormal];
    _repoButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_repoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_repoButton addTarget:self action:@selector(onClickedRepoButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_repoButton];
    
    _userButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _userButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_userButton setTitle:NSLocalizedString(@"User", @"") forState:UIControlStateNormal];
    _userButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_userButton addTarget:self action:@selector(onClickedUserButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userButton];
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    _separatorLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:_separatorLine];
    
    _sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sortButton.frame = CGRectMake(self.bounds.size.width - 68 - 10, 11, 68, 18);
    _sortButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_sortButton setTitle:@"Sort by" forState:UIControlStateNormal];
    _sortButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_sortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sortButton setTitleColor:UIColorFromRGB(0xb1b2b1) forState:UIControlStateHighlighted];
    [_sortButton setImage:ImageNamed(@"dropdown_arrow_normal") forState:UIControlStateNormal];
    [_sortButton setImage:ImageNamed(@"dropdown_arrow_selected") forState:UIControlStateHighlighted];
    [_sortButton layoutIfNeeded];
    _sortButton.titleEdgeInsets = UIEdgeInsetsMake(0, - _sortButton.imageView.frame.size.width * 2 - 8, 0, 0);
    _sortButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - _sortButton.titleLabel.frame.size.width * 2 - 8);
    [_sortButton addTarget:self action:@selector(onClickedSortButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sortButton];
    
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_repoButton, _userButton, _sortButton, _separatorLine);
        NSDictionary *metrics = @{@"buttonWidth":@(77)};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_repoButton(buttonWidth)][_userButton(buttonWidth)]" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_separatorLine(1)]-10-[_sortButton(68)]-10-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_repoButton]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-11-[_sortButton]-11-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_separatorLine]-14-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - Actions
- (void)onClickedRepoButton {
    BLOCK_SAFE_RUN(_repoButtonAction);
}

- (void)onClickedUserButton {
    BLOCK_SAFE_RUN(_userButtonAction);
}

- (void)onClickedSortButton {
    BLOCK_SAFE_RUN(_sortOrderAction);
}

@end
