//
//  GMTimeLineCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMTimeLineCell.h"


#define kTextDefaultColor           UIColorFromRGB(0x717175)
#define kTextHighlightedColor       UIColorFromRGB(0x0076ff)

#define kUserNameLinkTag        @"userNameLink"
#define kSourceRepoLinkTag      @"sourceRepoLink"   
#define kforkedResultLinkTag    @"forkedResultLink"

@interface MLGMTimeLineCell () <CCHLinkTextViewDelegate, TTTAttributedLabelDelegate>
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) TTTAttributedLabel *contentLinkLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) MLGMEvent *event;
@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation MLGMTimeLineCell

#pragma mark - init Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.contentLinkLabel];
        [self.contentView addSubview:self.updateTimeLabel];
        
        [self updateConstraintsIfNeeded];
    }
    return self;
}

#pragma mark- View Life Cycle

#pragma mark- Override Parent Methods
- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_avatarImageView, _contentLinkLabel, _updateTimeLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_avatarImageView(32)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_contentLinkLabel]-10-[_updateTimeLabel]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_avatarImageView(32)]-10-[_contentLinkLabel]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_avatarImageView(32)]-10-[_updateTimeLabel]-10-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark- SubViews Configuration

#pragma mark- Actions
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    BLOCK_SAFE_ASY_RUN_MainQueue(self.tapUserAction, self.event.actorName);
}

#pragma mark- Public Methods
- (void)configureCell:(MLGMEvent *)event {
    self.event = event;
    
    [self.avatarImageView sd_setImageWithURL:event.avatarUrl.toURL];
    
    NSMutableAttributedString *eventAttributedString = [NSMutableAttributedString new];
    
    NSAttributedString *actor = [[NSAttributedString alloc] initWithString:event.actorName
                                                                attributes:@{NSForegroundColorAttributeName : kTextHighlightedColor, CCHLinkAttributeName : kUserNameLinkTag}];
    [eventAttributedString appendAttributedString:actor];
    
    if ([event.type isEqualToString:@"WatchEvent"]) {
        NSAttributedString *actionType = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" starred "] attributes:nil];
        [eventAttributedString appendAttributedString:actionType];
    } else if ([event.type isEqualToString:@"ForkEvent"]) {
        NSAttributedString * actionType = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" fork "] attributes:nil];
        [eventAttributedString appendAttributedString:actionType];
    }
    
    NSAttributedString *sourceRepo = [[NSAttributedString alloc] initWithString:event.sourceRepoName attributes:@{NSForegroundColorAttributeName : kTextHighlightedColor, CCHLinkAttributeName : kSourceRepoLinkTag}];
    [eventAttributedString appendAttributedString:sourceRepo];
    
    if ([event.type isEqualToString:@"ForkEvent"]) {
        NSAttributedString * prep = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" to "] attributes:nil];
        [eventAttributedString appendAttributedString:prep];
        
        NSAttributedString *sourceRepo = [[NSAttributedString alloc] initWithString:event.targetRepoName attributes:@{NSForegroundColorAttributeName : kTextHighlightedColor, CCHLinkAttributeName : kforkedResultLinkTag}];
        [eventAttributedString appendAttributedString:sourceRepo];
    }
    
    self.contentLinkLabel.text = eventAttributedString;
    NSRange userNameRange = [self.contentLinkLabel.text rangeOfString:self.event.actorName];
    [self.contentLinkLabel addLinkToURL:[NSURL URLWithString:kUserNameLinkTag] withRange:userNameRange];
    NSRange sourceRepoRange = [self.contentLinkLabel.text rangeOfString:self.event.sourceRepoName];
    [self.contentLinkLabel addLinkToURL:[NSURL URLWithString:kSourceRepoLinkTag] withRange:sourceRepoRange];
    if ([event.type isEqualToString:@"ForkEvent"]) {
        NSRange targetRepoRange = [self.contentLinkLabel.text rangeOfString:self.event.targetRepoName];
        [self.contentLinkLabel addLinkToURL:[NSURL URLWithString:kforkedResultLinkTag] withRange:targetRepoRange];
    }
    
    self.updateTimeLabel.text = [event.createTime timeAgo];
}

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method
#pragma mark - CCHLinkTextViewDelegate
- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkWithValue:(id)value {
    if ([(NSString *)value isEqualToString:kUserNameLinkTag]) {
        BLOCK_SAFE_ASY_RUN_MainQueue(self.tapUserAction, self.event.actorName);
    } else if ([(NSString *)value isEqualToString:kSourceRepoLinkTag]) {
        BLOCK_SAFE_ASY_RUN_MainQueue(self.tapSourceRepoAction, self.event.sourceRepoName);
    } else if ([(NSString *)value isEqualToString:kforkedResultLinkTag]) {
        BLOCK_SAFE_ASY_RUN_MainQueue(self.tapForkRepoAction, self.event.targetRepoName);
    }
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"did select urlString: %@", url.absoluteString);
    if ([url.absoluteString isEqualToString:kUserNameLinkTag]) {
        BLOCK_SAFE_ASY_RUN_MainQueue(self.tapUserAction, self.event.actorName);
    } else if ([url.absoluteString isEqualToString:kSourceRepoLinkTag]) {
        BLOCK_SAFE_ASY_RUN_MainQueue(self.tapSourceRepoAction, self.event.sourceRepoName);
    } else if ([url.absoluteString isEqualToString:kforkedResultLinkTag]) {
        BLOCK_SAFE_ASY_RUN_MainQueue(self.tapForkRepoAction, self.event.targetRepoName);
    }
}

#pragma mark- Getter Setter
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView autoLayoutView];
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [_avatarImageView addGestureRecognizer:singleFingerTap];
    }
    
    return _avatarImageView;
}

- (TTTAttributedLabel *)contentLinkLabel {
    if (!_contentLinkLabel) {
        _contentLinkLabel = [TTTAttributedLabel autoLayoutView];
        _contentLinkLabel.numberOfLines = 0;
        _contentLinkLabel.linkAttributes = @{NSForegroundColorAttributeName: kTextHighlightedColor, NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
        _contentLinkLabel.delegate = self;
    }
    
    return _contentLinkLabel;
}

- (UILabel *)updateTimeLabel {
    if (!_updateTimeLabel) {
        _updateTimeLabel = [UILabel autoLayoutView];
        _updateTimeLabel.font = [UIFont systemFontOfSize:12];
        _updateTimeLabel.textColor = kTextDefaultColor;
    }
    
    return _updateTimeLabel;
}
#pragma mark- Helper Method

#pragma mark Temporary Area

@end
