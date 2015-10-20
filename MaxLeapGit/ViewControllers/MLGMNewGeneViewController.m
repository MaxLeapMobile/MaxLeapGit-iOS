//
//  GMAddNewGeneViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMNewGeneViewController.h"

@interface MLGMNewGeneViewController () <
UIPickerViewDelegate,
UIPickerViewDataSource,
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) NSArray *genesInBuild;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *allLanguage;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MLGMNewGeneViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.gene) {
        self.gene = [MLGMGene MR_createEntity];
        self.gene.userProfile = kOnlineAccountProfile;
    }
    
    [self configureSubViews];
    [self updateViewConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.gene.language && self.gene.skill) {
        NSUInteger languageIndex = [self.allLanguage indexOfObject:self.gene.language];
        NSDictionary *oneGene = [self.genesInBuild objectAtIndex:languageIndex];
        NSUInteger skillIndex = [oneGene[self.gene.language] indexOfObject:self.gene.skill];
        [self.pickerView selectRow:languageIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:skillIndex inComponent:1 animated:YES];
        [self.pickerView reloadComponent:1];
    }
}

#pragma mark- Override Parent Methods
- (void)updateViewConstraints {
    if (!_didSetupConstraints) {
        [self.tableView pinToSuperviewEdges:JRTViewPinAllEdges inset:0.0];
        
        [self.pickerView pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0];
        [self.pickerView constrainToHeight:200];
        [self.pickerView pinAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeBottom ofItem:self.view withConstant:0];
        
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
    NSString *selectedLanguage = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text;
    NSString *selectedSkill = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text;
    if (selectedLanguage.length && selectedSkill.length) {
        self.gene.updateTime = [NSDate date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [[MLGMWebService sharedInstance] saveGeneToMaxLeap:self.gene completion:^(BOOL success, NSError *error) {
            
        }];
    } else {
        [self.gene MR_deleteEntity];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - actions

#pragma mark- Public Methods

#pragma mark- Private Methods

#pragma mark- Delegate，DataSource, Callback Method
#pragma mark - UIPickerView Data Source & Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.genesInBuild count];
    } else {
        NSUInteger selectedRowInComponent0 = [self.pickerView selectedRowInComponent:0];
        NSDictionary *oneGene = self.genesInBuild[selectedRowInComponent0];
        NSString *language = [oneGene.allKeys firstObject];
        NSArray *skills = oneGene[language];
        return [skills count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSDictionary *oneGene = self.genesInBuild[row];
        NSString *language = [oneGene.allKeys firstObject];
        return language;
    } else {
        NSUInteger selectedRowInComponent0 = [self.pickerView selectedRowInComponent:0];
        NSDictionary *oneGene = self.genesInBuild[selectedRowInComponent0];
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
    NSDictionary *oneGene = self.genesInBuild[selectedGeneIndex];
    NSString *language = [oneGene.allKeys firstObject];
    self.gene.language = language;
    
    NSArray *skills = oneGene[language];
    NSUInteger selectedSkillIndex = component == 0 ? 0 : row;
    self.gene.skill = skills[selectedSkillIndex];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Language", @"");
        cell.detailTextLabel.text = self.gene.language;
    } else {
        cell.textLabel.text = NSLocalizedString(@"Skill", @"");
        cell.detailTextLabel.text = self.gene.skill;
    }
    
    return cell;
}

#pragma mark- Getter Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView autoLayoutView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
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
        [_pickerView addTopBorderWithColor:[UIColor lightGrayColor] width:1];
    }
    
    return _pickerView;
}

- (NSArray *)genesInBuild {
    NSArray *genes = [[NSBundle mainBundle] plistObjectFromResource:@"GeneInBuild.plist"];
    return genes;
}

#pragma mark- Helper Method
- (NSArray *)allLanguage {
    if (!_allLanguage) {
        NSMutableArray *allLanguage = [NSMutableArray new];
        [self.genesInBuild enumerateObjectsUsingBlock:^(NSDictionary *oneGene, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *language = [oneGene.allKeys firstObject];
            [allLanguage addObject:language];
        }];
        _allLanguage = [allLanguage copy];
    }
    
    return _allLanguage;
}

#pragma mark Temporary Area

@end