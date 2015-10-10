//
//  MLGMRecommendEmptyView.m
//  MaxLeapGit
//
//  Created by julie on 15/10/10.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMRecommendEmptyView.h"
#import "MLGMStringUtil.h"

#define kTextFont               [UIFont systemFontOfSize:16]
#define kHightlightedTextColor  [UIColor blueColor]

@interface MLGMRecommendEmptyView ()

@property (nonatomic, copy) dispatch_block_t addNewGeneAction;
@property (nonatomic, copy) dispatch_block_t replayAction;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *addNewGeneLabel;
@property (nonatomic, strong) UILabel *replayLabel;

@property (nonatomic, assign) BOOL didSetUpConstraints;
@end


@implementation MLGMRecommendEmptyView
- (instancetype)initWithFrame:(CGRect)frame addNewGeneAction:(dispatch_block_t)addNewGeneAction replayAction:(dispatch_block_t)replayAction {
    self = [super initWithFrame:frame];
    if (self) {

        _addNewGeneAction = addNewGeneAction;
        _replayAction = replayAction;
        
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    _topLabel = [[UILabel alloc] init];
    _topLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.text = NSLocalizedString(@"That's all about it!", @"");
    _topLabel.font = kTextFont;
    [self addSubview:_topLabel];
   
    _addNewGeneLabel = [self createLabelWithAction:@selector(onTappedAddNewGeneLabel)];
    [_addNewGeneLabel setAttributedText:[self attributedStringForAddNewGeneLabel]];
    [self addSubview:_addNewGeneLabel];
  
    _replayLabel = [self createLabelWithAction:@selector(onTappedReplayLabel)];
    [_replayLabel setAttributedText:[self attributedStringForReplayLabel]];
    [self addSubview:_replayLabel];
    
    [self updateConstraintsIfNeeded];
}

- (NSAttributedString *)attributedStringForAddNewGeneLabel {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Add new genes",@"") attributes:@{NSForegroundColorAttributeName : kHightlightedTextColor, NSFontAttributeName : kTextFont}];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@" to find more repos worth recommending",@"") attributes:@{NSFontAttributeName : kTextFont}]];
    return string;
}

- (NSAttributedString *)attributedStringForReplayLabel {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Or you can ",@"") attributes:@{NSFontAttributeName : kTextFont}];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"view this recommendation list again",@"") attributes:@{NSForegroundColorAttributeName : kHightlightedTextColor, NSFontAttributeName : kTextFont}]];
    return string;
}

- (UILabel *)createLabelWithAction:(SEL)action {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [label addGestureRecognizer:tap];
    return label;
}

- (void)updateConstraints {
    [self removeConstraints:self.constraints];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_topLabel, _addNewGeneLabel, _replayLabel);
    
    CGFloat topLabelHeight = [MLGMStringUtil sizeInOneLineOfText:_topLabel.text font:kTextFont].height;
    CGFloat addNewGeneLabelHeight = [MLGMStringUtil sizeOfText:_addNewGeneLabel.text font:kTextFont constrainedToSize:CGSizeMake(self.bounds.size.width - 20 * 2, 500)].height;
    CGFloat replayLabelHeight = [MLGMStringUtil sizeOfText:_replayLabel.text font:kTextFont constrainedToSize:CGSizeMake(self.bounds.size.width - 20 * 2, 500)].height;
    CGFloat topMargin = (self.bounds.size.height - topLabelHeight - 24 - addNewGeneLabelHeight - 20 - replayLabelHeight) / 2;
    
    NSDictionary *metrics = @{@"margin":@(topMargin),
                              @"h1":@(topLabelHeight),
                              @"h2":@(addNewGeneLabelHeight),
                              @"h3":@(replayLabelHeight)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_topLabel(h1)]-24-[_addNewGeneLabel(h2)]-20-[_replayLabel(h3)]" options:NSLayoutFormatAlignAllCenterX | NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.bounds.size.width - 20 * 2]];
    
    [super updateConstraints];
}

#pragma mark - Actions
- (void)onTappedAddNewGeneLabel {
    if (_addNewGeneAction) {
        _addNewGeneAction();
    }
}

- (void)onTappedReplayLabel {
    if (_replayAction) {
        _replayAction();
    }
}

@end
