//
//  GMAddNewGeneViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMAddNewGeneViewController.h"

//Skill---Language
#define kPopularGenesArray @[@"html5---Html", @"bootstrap---Html", @"Android---Java", @"spring---Java", @"angularjs---Javascript", @"bootstrap---Javascript", @"jquery---Javascript", @"node---Javascript", @"iOS---Objective-C", @"Codeigniter---PHP", @"web framework---Python", @"iOS---Swift", @"asp---C#", @"xamarin---C#"]

@interface MLGMAddNewGeneViewController ()
@property (nonatomic, strong) NSArray *popularGenesArray;
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
    _popularGenesArray = [kPopularGenesArray sortedArrayUsingSelector:@selector(compare:)];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return _popularGenesArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = indexPath.section == 0 ? @"addNewGeneCell" : @"popularGeneCell";
    UITableViewCellStyle cellStyle = indexPath.section == 0 ? UITableViewCellStyleDefault : UITableViewCellStyleSubtitle;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = indexPath.row == 0 ? NSLocalizedString(@"Language", @"") : NSLocalizedString(@"Skills", @"");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        NSString *skillAndLanguagePair = _popularGenesArray[indexPath.row];
        NSArray *array = [skillAndLanguagePair componentsSeparatedByString:@"---"];
        NSString *skill = [array firstObject];
        NSString *language = [array lastObject];
        cell.textLabel.text = skill;
        cell.detailTextLabel.text = language;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"Add New Gene", @"");
    } else {
        return NSLocalizedString(@"Popular Genes", @"");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

@end
