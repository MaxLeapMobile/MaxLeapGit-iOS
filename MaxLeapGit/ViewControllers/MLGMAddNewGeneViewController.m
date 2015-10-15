//
//  GMAddNewGeneViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMAddNewGeneViewController.h"
#import "MLGMStringUtil.h"

#define kPickerViewHeight      200

@interface MLGMAddNewGeneViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSDictionary *genesDict;
@property (nonatomic, strong) NSArray *languages;

@property (nonatomic, copy) NSString *selectedLanguage;
@property (nonatomic, copy) NSString *selectedSkill;

@property(nonatomic, strong) UIView *pickerContainer;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation MLGMAddNewGeneViewController
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = NSLocalizedString(@"Add new gene", @"");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    
    [self loadData];
}

- (void)loadData {
    _genesDict = @{@"Html":@[@"html5", @"bootstrap"],
                   @"Java":@[@"Android", @"spring"],
                   @"Javascript":@[@"angularjs", @"bootstrap", @"jquery", @"node"],
                   @"Objective-C":@[@"iOS"],
                   @"PHP":@[@"Codeigniter"],
                   @"Python":@[@"web framework"],
                   @"Swift":@[@"iOS"],
                   @"C#":@[@"asp", @"xamarin"],
                   };
    _languages = @[@"Html", @"Java", @"Javascript", @"Objective-C", @"PHP", @"Python", @"Swift", @"C#"];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Language", @"");
        cell.detailTextLabel.text = _selectedLanguage;
    } else {
        cell.textLabel.text = NSLocalizedString(@"Skill", @"");
        cell.detailTextLabel.text = _selectedSkill;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
    [self showPickerView];
}


#pragma mark - actions
- (void)showPickerView {
    if (_pickerContainer.superview) {
        return;
    }
    
    _pickerContainer = [[UIView alloc] init];
    _pickerContainer.frame = CGRectMake(0, self.tableView.bounds.size.height - 200, self.tableView.bounds.size.width, 200);
    _pickerContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _pickerContainer.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:_pickerContainer];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];//////
    topLine.backgroundColor = [UIColor lightGrayColor];
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_pickerContainer addSubview:topLine];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    btnDone.frame = CGRectMake(_pickerContainer.bounds.size.width - 100, 0, 90, 40);
    
    btnDone.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [btnDone setTitle:NSLocalizedString(@"Done", @"") forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(onClickedDone) forControlEvents:UIControlEventTouchUpInside];
    [_pickerContainer addSubview:btnDone];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, _pickerContainer.bounds.size.width, _pickerContainer.bounds.size.height - 40)];
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [_pickerContainer addSubview:_pickerView];
    
    CGRect originalFrame = _pickerContainer.frame;
    CGRect newFrame = _pickerContainer.frame;
    newFrame.origin.y += 200;
    _pickerContainer.frame = newFrame;
    [UIView animateWithDuration:0.3 animations:^{
        _pickerContainer.frame = originalFrame;
    }];
}

- (void)onClickedDone {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _pickerContainer.frame;
        frame.origin.y += 200;
        _pickerContainer.frame = frame;
    } completion:^(BOOL finished) {
        [_pickerContainer removeFromSuperview];
        _pickerContainer = nil;
    }];
}

#pragma mark - UIPickerView Data Source & Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _languages.count;
    } else {
        NSUInteger selectedRowInComponent0 = [_pickerView selectedRowInComponent:0];
        NSString *language = _languages[selectedRowInComponent0];
        NSArray *skills = _genesDict[language];
        return skills.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSString *language = _languages[row];
        return language;
    } else {
        NSUInteger selectedRowInComponent0 = [_pickerView selectedRowInComponent:0];
        NSString *language = _languages[selectedRowInComponent0];
        NSArray *skills = _genesDict[language];
        return skills[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _selectedLanguage = _languages[row];
        [_pickerView reloadComponent:1];
       
        NSUInteger selectedRowInComponent1 = [_pickerView selectedRowInComponent:1];
        NSArray *skills = _genesDict[_selectedLanguage];
        _selectedSkill = skills[selectedRowInComponent1];
        
    } else {
        NSUInteger selectedRowInComponent0 = [_pickerView selectedRowInComponent:0];
        NSString *language = _languages[selectedRowInComponent0];
        NSArray *skills = _genesDict[language];
        _selectedSkill = skills[row];
    }
    [self.tableView reloadData];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 32;
}

@end
