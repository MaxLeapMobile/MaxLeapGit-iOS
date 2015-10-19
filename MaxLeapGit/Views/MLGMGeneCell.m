//
//  MLGMGeneCell.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/19.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMGeneCell.h"

@interface MLGMGeneCell ()
@property (nonatomic, strong) UIButton *editingButton;
@property (nonatomic, strong) MLGMGene *gene;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MLGMGeneCell

#pragma mark - init Method
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.editingButton];
    
    return self;
}

#pragma mark- View Life Cycle

#pragma mark- Override Parent Methods
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    if (!_didSetupConstraints) {
        [self.editingButton pinToSuperviewEdges:JRTViewPinTopEdge | JRTViewPinBottomEdge inset:0.0];
        [self.editingButton pinToSuperviewEdges:JRTViewPinRightEdge inset:40];
        [self.editingButton constrainToWidth:40];
        
        _didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark- SubViews Configuration

#pragma mark- Actions
- (void)editingButtonPressed:(id)sender {
    BLOCK_SAFE_ASY_RUN_MainQueue(self.editingButtonEventHandler, self.gene);
}

#pragma mark- Public Methods
- (void)configureCell:(MLGMGene *)gene {
    self.gene = gene;
    self.textLabel.text = gene.skill;
    self.detailTextLabel.text = gene.language;
}

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark- Getter Setter
- (UIButton *)editingButton {
    if (!_editingButton) {
        _editingButton = [UIButton autoLayoutView];
        [_editingButton setImage:ImageNamed(@"edit_icon_normal") forState:UIControlStateNormal];
        [_editingButton setImage:ImageNamed(@"edit_icon_selected") forState:UIControlStateNormal];
        [_editingButton addTarget:self action:@selector(editingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editingButton;
}

#pragma mark- Helper Method

#pragma mark Temporary Area

@end
