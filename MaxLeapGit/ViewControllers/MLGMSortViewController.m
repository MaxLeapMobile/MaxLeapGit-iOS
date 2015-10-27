//
//  MLGMSortViewController.m
//  MaxLeapGit
//
//  Created by Julie on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMSortViewController.h"

#define kRepoSortMethods       @[@"Best match (Default)", @"Most stars", @"Most forks", @"Recently updated"]
#define kUserSortMethods       @[@"Best match (Default)", @"Followers", @"Repositories", @"Joined"]

@interface MLGMSortViewController ()
@property (nonatomic, strong) NSArray *sortMethods;
@property (nonatomic, assign) NSUInteger selectedIndex;
@end

@implementation MLGMSortViewController
- (instancetype)initWithGroupType:(MLGMSortGroupType)type selectedIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
       
        _sortMethods = type == MLGMSortGroupTypeRepo ? kRepoSortMethods : kUserSortMethods;
        _selectedIndex = index;
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
    if (indexPath.row == _selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = UIColorFromRGB(0x0076ff);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    
    if (self.delegate) {
        [self.delegate sortViewControllerDidSelectRowAtIndex:_selectedIndex];
    }
}

@end
