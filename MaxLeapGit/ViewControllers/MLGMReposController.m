//
//  MLGMReposController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/12.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "MLGMReposController.h"
#import "MLGMRepoCell.h"
#import "MLGMRepoDetailController.h"
#import "MLGMTabBarController.h"

@interface MLGMReposController ()
@property (nonatomic, assign) MLGMReposControllerType type;
@property (nonatomic, strong) NSArray *data;
@end

@implementation MLGMReposController

- (instancetype)initWithType:(MLGMReposControllerType)type {
    self = [super init];
    if (self) {
        _type = type;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
     self.tableView.rowHeight = UITableViewAutomaticDimension;
     self.tableView.estimatedRowHeight = 105;
    
    [self loadData];
    [self configureUI];
}

- (void)loadData {
    _data = @[@"", @""];//temp
}

- (void)configureUI {
    if (_type == MLGMReposControllerTypeRepos) {
        self.title = NSLocalizedString(@"Repos", @"");
    } else if (_type == MLGMReposControllerTypeStars) {
        self.title = NSLocalizedString(@"Stars", @"");
    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MLGMRepoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MLGMRepoDetailController *repoDetailVC = [[MLGMRepoDetailController alloc] init];
    repoDetailVC.url = @"https://github.com/AFNetworking/AFNetworking";
    [self.navigationController pushViewController:repoDetailVC animated:YES];
}

@end
