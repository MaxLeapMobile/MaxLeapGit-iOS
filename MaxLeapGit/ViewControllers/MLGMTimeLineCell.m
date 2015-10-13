//
//  GMTimeLineCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMTimeLineCell.h"
#import <CCHLinkTextView/CCHLinkTextView.h>
#import <CCHLinkTextView/CCHLinkTextViewDelegate.h>
#import "MLGMRepoDetailController.h"

#define kTextDefaultColor           UIColorWithRBGA(113, 113, 117, 1)
#define kTextHighlightedColor       UIColorWithRBGA(0, 118, 255, 1)

#define kUserNameLinkTag        @"userNameLink"
#define kSourceRepoLinkTag      @"sourceRepoLink"   
#define kforkedResultLinkTag    @"forkedResultLink"

@interface MLGMTimeLineCell () <CCHLinkTextViewDelegate>
//data -- temp
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *actionName; //starred; forked
@property (nonatomic, strong) NSString *sourceRepoName;
@property (nonatomic, strong) NSString *forkedResultName;

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) CCHLinkTextView *textView;
@property (nonatomic, strong) UILabel *updateTimeLabel;

@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation MLGMTimeLineCell
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
    
    _textView = [[CCHLinkTextView alloc] init];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    _textView.linkDelegate = self;
    [self.contentView addSubview:_textView];
 
    _updateTimeLabel = [[UILabel alloc] init];
    _updateTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _updateTimeLabel.font = [UIFont systemFontOfSize:12];
    _updateTimeLabel.textColor = kTextDefaultColor;
    [self.contentView addSubview:_updateTimeLabel];
   
    //temp
    _icon.layer.borderWidth = 1;
    _icon.layer.borderColor = [UIColor grayColor].CGColor;
    [self updateData:nil];
    
    [self updateConstraintsIfNeeded];
}

- (void)updateData:(id)data {
   //temp
    _userName = @"abc";
    _actionName = @"forked";
    _sourceRepoName = @"source/repo1";
    _forkedResultName = @"abc/repo1";
    
    _textView.attributedText = [self attributedStringForTextView];
    
    _updateTimeLabel.text = @"1 hour ago";
}

- (NSAttributedString *)attributedStringForTextView {
    //fork: a forked b/repo1 to a/repo1
    //star: a starred b/repo1
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:_userName attributes:@{NSForegroundColorAttributeName : kTextHighlightedColor, CCHLinkAttributeName : kUserNameLinkTag}]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", _actionName] attributes:nil]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:_sourceRepoName attributes:@{NSForegroundColorAttributeName : kTextHighlightedColor, CCHLinkAttributeName : kSourceRepoLinkTag}]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" to " attributes:nil]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:_forkedResultName attributes:@{NSForegroundColorAttributeName : kTextHighlightedColor, CCHLinkAttributeName : kforkedResultLinkTag}]];
    return string;
}

- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_icon, _textView, _updateTimeLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_icon(32)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_textView]-10-[_updateTimeLabel]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(32)]-10-[_textView]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_icon(32)]-10-[_updateTimeLabel]-10-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - CCHLinkTextViewDelegate
- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkWithValue:(id)value {
    if ([(NSString *)value isEqualToString:kUserNameLinkTag]) {
        BLOCK_SAFE_RUN(_tapUserAction);
    } else if ([(NSString *)value isEqualToString:kSourceRepoLinkTag]) {
        BLOCK_SAFE_RUN(_tapSourceRepoAction);
    } else if ([(NSString *)value isEqualToString:kforkedResultLinkTag]) {
        //tapped forkedResultName

    }
}

@end
