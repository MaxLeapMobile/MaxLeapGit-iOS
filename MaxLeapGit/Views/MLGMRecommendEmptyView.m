//
//  MLGMRecommendEmptyView.m
//  MaxLeapGit
//
//  Created by julie on 15/10/10.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMRecommendEmptyView.h"
#import "MLGMStringUtil.h"
#import <CCHLinkTextView/CCHLinkTextView.h>
#import <CCHLinkTextView/CCHLinkTextViewDelegate.h>

#define kTextFont               [UIFont systemFontOfSize:16]
#define kHightlightedTextColor  [UIColor blueColor]

#define kAddNewGenesLinkTag                 @"addNewGenesLink"
#define kReplayRecommendationListLinkTag    @"replayRecommendationList"

@interface MLGMRecommendEmptyView () <CCHLinkTextViewDelegate>

@property (nonatomic, copy) dispatch_block_t addNewGeneAction;
@property (nonatomic, copy) dispatch_block_t replayAction;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) CCHLinkTextView *addNewGeneTextView;
@property (nonatomic, strong) CCHLinkTextView *replayTextView;

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
   
    _addNewGeneTextView = [[CCHLinkTextView alloc] init];
    _addNewGeneTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _addNewGeneTextView.linkDelegate = self;
    _addNewGeneTextView.attributedText = [self attributedStringForaddNewGeneTextView];
    [self addSubview:_addNewGeneTextView];
    
    _replayTextView = [[CCHLinkTextView alloc] init];
    _replayTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _replayTextView.linkDelegate = self;
    _replayTextView.attributedText = [self attributedStringForreplayTextView];
    [self addSubview:_replayTextView];
    
    [self updateConstraintsIfNeeded];
}

- (NSAttributedString *)attributedStringForaddNewGeneTextView {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Add new genes",@"") attributes:@{NSForegroundColorAttributeName : kHightlightedTextColor, NSFontAttributeName : kTextFont, CCHLinkAttributeName : kAddNewGenesLinkTag}];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@" to find more repos worth recommending",@"") attributes:@{NSFontAttributeName : kTextFont}]];
    return string;
}

- (NSAttributedString *)attributedStringForreplayTextView {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Or you can ",@"") attributes:@{NSFontAttributeName : kTextFont}];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"view this recommendation list again",@"") attributes:@{NSForegroundColorAttributeName : kHightlightedTextColor, NSFontAttributeName : kTextFont, CCHLinkAttributeName : kReplayRecommendationListLinkTag}]];
    return string;
}

//- (UILabel *)createLabelWithAction:(SEL)action {
//    UILabel *label = [[UILabel alloc] init];
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    label.numberOfLines = 0;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
//    [label addGestureRecognizer:tap];
//    return label;
//}

- (void)updateConstraints {
    [self removeConstraints:self.constraints];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_topLabel, _addNewGeneTextView, _replayTextView);
    
    CGFloat topLabelHeight = [MLGMStringUtil sizeInOneLineOfText:_topLabel.text font:kTextFont].height;
    CGFloat addNewGeneTextViewHeight = [MLGMStringUtil sizeOfText:_addNewGeneTextView.text font:kTextFont constrainedToSize:CGSizeMake(self.bounds.size.width - 20 * 2, 500)].height + 20;
    CGFloat replayTextViewHeight = [MLGMStringUtil sizeOfText:_replayTextView.text font:kTextFont constrainedToSize:CGSizeMake(self.bounds.size.width - 20 * 2, 500)].height + 20;
    CGFloat topMargin = (self.bounds.size.height - topLabelHeight - 24 - addNewGeneTextViewHeight - 20 - replayTextViewHeight) / 2;
    
    NSDictionary *metrics = @{@"margin":@(topMargin),
                              @"h1":@(topLabelHeight),
                              @"h2":@(addNewGeneTextViewHeight),
                              @"h3":@(replayTextViewHeight)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_topLabel(h1)]-24-[_addNewGeneTextView(h2)]-20-[_replayTextView(h3)]" options:NSLayoutFormatAlignAllCenterX | NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_topLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.bounds.size.width - 20 * 2]];
    
    [super updateConstraints];
}

#pragma mark - CCHLinkTextViewDelegate
- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkWithValue:(id)value {
    if ([(NSString *)value isEqualToString:kAddNewGenesLinkTag]) {
        BLOCK_SAFE_RUN(_addNewGeneAction);
    } else if ([(NSString *)value isEqualToString:kReplayRecommendationListLinkTag]) {
        BLOCK_SAFE_RUN(_replayAction);
    }
}

@end
