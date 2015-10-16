//
//  GMGenesViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMGenesViewController.h"
#import "MLGMAddNewGeneViewController.h"
#import "MLGMAddNewGeneViewController.h"
#import "MLGMTabBarController.h"
#import "MLGMWebService.h"

@interface MLGMGenesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *genes;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addNewGeneButton;
@end

@implementation MLGMGenesViewController
#pragma mark - init Method

#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Genes", @"");
   
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
    self.navigationController.navigationBarHidden = NO;
    
    [self configureSubViews];
    
    __weak typeof(self) wSelf = self;
    MLGMAccount *accountMOC = [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES)];
    [[MLGMWebService sharedInstance] fetchGenesForUserName:accountMOC.actorProfile.loginName completion:^(NSArray *genes, NSError *error) {
        NSLog(@"fetch genes--- result = %@", genes);
        wSelf.genes = genes;
        [wSelf.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self transparentNavigationBar:NO];
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
}

#pragma mark- SubView Configuration
- (void)configureSubViews {
    [self.view addSubview:self.addNewGeneButton];
}

#pragma mark- Action
- (void)onClickedEditGeneButton {
    [self presentAddNewGenePage];
}

- (void)onClickedAddNewGeneButton {
    [self presentAddNewGenePage];
}

- (void)presentAddNewGenePage {
    MLGMAddNewGeneViewController *addNewGeneVC = [[MLGMAddNewGeneViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addNewGeneVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark- Delegate，DataSource, Callback Method
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _genes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = CGRectMake(self.view.bounds.size.width - 40, 0, 40, cell.bounds.size.height);
        [editButton setImage:ImageNamed(@"edit_icon_normal") forState:UIControlStateNormal];
        [editButton setImage:ImageNamed(@"edit_icon_selected") forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(onClickedEditGeneButton) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:editButton];
    }
    MLGMGene *gene = _genes[indexPath.row];
    cell.textLabel.text = gene.skill;
    cell.detailTextLabel.text = gene.language;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        MLGMAddNewGeneViewController *vcAddGene = [[MLGMAddNewGeneViewController alloc] init];
        [self.navigationController pushViewController:vcAddGene animated:YES];
    }
}

#pragma mark- Override Parent Method

#pragma mark- Private Method

#pragma mark- Getter Setter
- (UIButton *)addNewGeneButton {
    if (!_addNewGeneButton) {
        _addNewGeneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _addNewGeneButton.frame = CGRectMake(0, self.view.bounds.size.height - 64 - 44, self.view.bounds.size.width, 44);
        _addNewGeneButton.backgroundColor = BottomToolBarColor;
        [_addNewGeneButton setTitle:NSLocalizedString(@"Add new gene", @"") forState:UIControlStateNormal];
        [_addNewGeneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addNewGeneButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_addNewGeneButton addTarget:self action:@selector(onClickedAddNewGeneButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addNewGeneButton;
}

#pragma mark- Helper Method
@end
