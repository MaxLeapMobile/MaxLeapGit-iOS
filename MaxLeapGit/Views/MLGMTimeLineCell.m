//
//  GMTimeLineCell.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMTimeLineCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CCHLinkTextView/CCHLinkTextView.h>
#import <CCHLinkTextView/CCHLinkTextViewDelegate.h>
#import "MLGMRepoDetailController.h"
#import "NSDate+TimeAgo.h"
#import "UITableViewCell+Extension.h"

#define kTextDefaultColor           UIColorWithRBGA(113, 113, 117, 1)
#define kTextHighlightedColor       UIColorWithRBGA(0, 118, 255, 1)

#define kUserNameLinkTag        @"userNameLink"
#define kSourceRepoLinkTag      @"sourceRepoLink"   
#define kforkedResultLinkTag    @"forkedResultLink"

@interface MLGMTimeLineCell () <CCHLinkTextViewDelegate>
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) CCHLinkTextView *contentLinkTextView;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) MLGMEvent *event;
@property (nonatomic, assign) BOOL didSetUpConstraints;
@end

@implementation MLGMTimeLineCell

#pragma mark - init Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.layer.borderColor = [UIColor grayColor].CGColor;
        [self.contentView addSubview:_avatarImageView];
        
        _contentLinkTextView = [[CCHLinkTextView alloc] init];
        _contentLinkTextView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentLinkTextView.linkDelegate = self;
        [self.contentView addSubview:_contentLinkTextView];
        
        _updateTimeLabel = [[UILabel alloc] init];
        _updateTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _updateTimeLabel.font = [UIFont systemFontOfSize:12];
        _updateTimeLabel.textColor = kTextDefaultColor;
        [self.contentView addSubview:_updateTimeLabel];
        
        [self updateConstraintsIfNeeded];
    }
    return self;
}

#pragma mark- View Life Cycle

#pragma mark- Override Parent Methods
- (void)updateConstraints {
    if (!_didSetUpConstraints) {
        NSDictionary *views = NSDictionaryOfVariableBindings(_avatarImageView, _contentLinkTextView, _updateTimeLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_avatarImageView(32)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_contentLinkTextView]-10-[_updateTimeLabel]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_avatarImageView(32)]-10-[_contentLinkTextView]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_avatarImageView(32)]-10-[_updateTimeLabel]-10-|" options:0 metrics:nil views:views]];
        
        _didSetUpConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark- SubViews Configuration

#pragma mark- Actions

#pragma mark- Public Methods
- (void)configureCell:(MLGMEvent *)event {
    self.event = event;
    
    [_avatarImageView sd_setImageWithURL:event.avatarUrl.toURL];
    
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
    
    self.contentLinkTextView.attributedText = eventAttributedString;
    _updateTimeLabel.text = [event.createdAt description];
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

#pragma mark- Getter Setter

#pragma mark- Helper Method

#pragma mark Temporary Area

@end
