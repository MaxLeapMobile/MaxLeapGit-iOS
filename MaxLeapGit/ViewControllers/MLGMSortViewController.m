//
//  MLGMSortViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/9.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMSortViewController.h"

@interface MLGMSortViewController ()
@property (nonatomic, strong) NSArray *sortMethods;

@property (nonatomic, copy) NSString *selectedMethod;
@end

@implementation MLGMSortViewController
- (instancetype)initWithSortGroupType:(MLGMSortGroupType)type selectedSortMethod:(NSString *)selectedMethod {
    self = [super init];
    if (self) {

        if (type == MLGMSortGroupTypeRepo) {
            _sortMethods = @[@"Best match (Default)", @"Most stars", @"Most forks", @"Recently updated"];
        } else {
            _sortMethods = @[@"Best match (Default)", @"Followers", @"Repositories", @"Joined"];
        }
        
        _selectedMethod = selectedMethod.length ? selectedMethod : [_sortMethods firstObject];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortMethods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    cell.textLabel.text = _sortMethods[indexPath.row];
    if ([cell.textLabel.text isEqualToString:_selectedMethod]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = UIColorWithRGBA(0, 118, 255, 1);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate) {
        [self.delegate sortViewControllerDidSelectSortMethod:_sortMethods[indexPath.row]];
    }
}

@end
