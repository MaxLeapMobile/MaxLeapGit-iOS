//
//  GMAddNewGeneViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMAddNewGeneViewController.h"
#import "MLGMStringUtil.h"
#import "NSBundle+Extension.h"
#import "UIView+CustomBorder.h"

@interface MLGMAddNewGeneViewController () <
UIPickerViewDelegate,
UIPickerViewDataSource,
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *genes;
@property (nonatomic, copy) NSString *selectedLanguage;
@property (nonatomic, copy) NSString *selectedSkill;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL isPickerViewPoped;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSLayoutConstraint *pickerViewBottomConstraints;
@end

@implementation MLGMAddNewGeneViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubViews];
}

#pragma mark- Override Parent Methods
- (void)updateViewConstraints {
    if (!_didSetupConstraints) {
        [self.tableView pinToSuperviewEdges:JRTViewPinAllEdges inset:0.0];
        [self.pickerView pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        [self.pickerView constrainToHeight:200];
        self.pickerView.layer.borderColor = [UIColor redColor].CGColor;
        self.pickerView.layer.borderWidth = 1.0f;

        self.pickerViewBottomConstraints = [self.pickerView pinAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeBottom ofItem:self.view withConstant:0];
        
        _didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark- SubViews Configuration
- (void)configureSubViews {
    self.title = NSLocalizedString(@"Add new gene", @"");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.pickerView];
}

#pragma mark- Actions
- (void)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - actions
- (void)showPickerView {
    [self.view layoutIfNeeded];
    if (self.isPickerViewPoped) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerViewBottomConstraints.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isPickerViewPoped = YES;
    }];
}

- (void)hiddenPickerView {
    [self.view layoutIfNeeded];
    if (!self.isPickerViewPoped) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerViewBottomConstraints.constant = -200;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isPickerViewPoped = YES;
    }];
}

#pragma mark- Public Methods

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method
#pragma mark - UIPickerView Data Source & Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.genes count];
    } else {
        NSUInteger selectedRowInComponent0 = [self.pickerView selectedRowInComponent:0];
        NSDictionary *oneGene = self.genes[selectedRowInComponent0];
        NSString *language = [oneGene.allKeys firstObject];
        NSArray *skills = oneGene[language];
        return [skills count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSDictionary *oneGene = self.genes[row];
        NSString *language = [oneGene.allKeys firstObject];
        return language;
    } else {
        NSUInteger selectedRowInComponent0 = [self.pickerView selectedRowInComponent:0];
        NSDictionary *oneGene = self.genes[selectedRowInComponent0];
        NSString *language = [oneGene.allKeys firstObject];
        NSArray *skills = oneGene[language];
        return skills[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    }
    
    NSUInteger selectedGeneIndex = component == 0 ? row : [self.pickerView selectedRowInComponent:0];
    NSDictionary *oneGene = self.genes[selectedGeneIndex];
    NSString *language = [oneGene.allKeys firstObject];
    self.selectedLanguage = language;
    
    NSArray *skills = oneGene[language];
    NSUInteger selectedSkillIndex = component == 0 ? 0 : row;
    self.selectedSkill = skills[selectedSkillIndex];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self showPickerView];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Language", @"");
        cell.detailTextLabel.text = self.selectedLanguage;
    } else {
        cell.textLabel.text = NSLocalizedString(@"Skill", @"");
        cell.detailTextLabel.text = self.selectedSkill;
    }
    
    return cell;
}

#pragma mark- Getter Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView autoLayoutView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    
    return _tableView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [UIPickerView autoLayoutView];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        [_pickerView addTopBorderWithColor:[UIColor grayColor] width:1];
    }
    
    return _pickerView;
}

- (NSArray *)genes {
    NSArray *genes = [[NSBundle mainBundle] plistObjectFromResource:@"GeneInBuild.plist"];
    return genes;
}

//- (NSString *)languageInGenes:(NSInteger)index {
//    NSDictionary *oneGene = self.genes[index];
//    NSString *language = [oneGene.allKeys firstObject];
//    return language;
//}
//
//- (NSString *)skillInLanguage:(NSString *)language {
//    
//}
//
//- (NSString *)language
#pragma mark- Helper Method

#pragma mark Temporary Area

@end
