//
//  MLGMRecommendEmptyView.m
//  MaxLeapGit
//
//  Created by julie on 15/10/10.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMRecommendEmptyView.h"

#define kTextHighlightedColor       UIColorFromRGB(0x0076ff)
#define kTextFont               [UIFont systemFontOfSize:16]

#define kDefaultTextColor       UIColorFromRGB(0x808080)
#define kHightlightedTextColor  UIColorFromRGB(0x0076FF)

#define kAddNewGenesLinkTag                 @"addNewGenesLink"
#define kReplayRecommendationListLinkTag    @"replayRecommendationList"

@interface MLGMRecommendEmptyView () <TTTAttributedLabelDelegate>

@property (nonatomic, copy) dispatch_block_t addNewGeneAction;
@property (nonatomic, copy) dispatch_block_t replayAction;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) TTTAttributedLabel *addNewGeneTextView;
@property (nonatomic, strong) TTTAttributedLabel *replayTextView;

@property (nonatomic, strong) TTTAttributedLabel *contentLinkLabel;

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

    _addNewGeneTextView = [TTTAttributedLabel autoLayoutView];
    _addNewGeneTextView.numberOfLines = 0;
    _addNewGeneTextView.linkAttributes = @{NSForegroundColorAttributeName: kTextHighlightedColor, NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    _addNewGeneTextView.delegate = self;
    [self addSubview:_addNewGeneTextView];
    
    _addNewGeneTextView.text = [self attributedStringForaddNewGeneTextView];
    NSRange addNewGeneTextRange = [_addNewGeneTextView.text rangeOfString:NSLocalizedString(@"Add new genes",@"")];
    [_addNewGeneTextView addLinkToURL:[NSURL URLWithString:kAddNewGenesLinkTag] withRange:addNewGeneTextRange];
    
    _replayTextView = [TTTAttributedLabel autoLayoutView];
    _replayTextView.numberOfLines = 0;
    _replayTextView.linkAttributes = @{NSForegroundColorAttributeName: kTextHighlightedColor, NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    _replayTextView.delegate = self;
    [self addSubview:_replayTextView];
    
    _replayTextView.text = [self attributedStringForreplayTextView];
    NSRange replayTextRange = [_replayTextView.text rangeOfString:NSLocalizedString(@"view this recommendation list again",@"")];
    [_replayTextView addLinkToURL:[NSURL URLWithString:kReplayRecommendationListLinkTag] withRange:replayTextRange];
    
    [self updateConstraintsIfNeeded];
}

- (NSAttributedString *)attributedStringForaddNewGeneTextView {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Add new genes",@"") attributes:@{NSForegroundColorAttributeName : kHightlightedTextColor, NSFontAttributeName : kTextFont}];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@" to find more repos worth recommending",@"") attributes:@{NSFontAttributeName : kTextFont, NSForegroundColorAttributeName : kDefaultTextColor}]];
    return string;
}

- (NSAttributedString *)attributedStringForreplayTextView {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Or you can ",@"") attributes:@{NSFontAttributeName : kTextFont, NSForegroundColorAttributeName : kDefaultTextColor}];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"view this recommendation list again",@"") attributes:@{NSForegroundColorAttributeName : kHightlightedTextColor, NSFontAttributeName : kTextFont}]];
    return string;
}

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

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"did select urlString: %@", url.absoluteString);
    if ([url.absoluteString isEqualToString:kAddNewGenesLinkTag]) {
        BLOCK_SAFE_ASY_RUN_MainQueue(_addNewGeneAction);
    } else if ([url.absoluteString isEqualToString:kReplayRecommendationListLinkTag]) {
        BLOCK_SAFE_ASY_RUN_MainQueue(_replayAction);
    }
}

@end
