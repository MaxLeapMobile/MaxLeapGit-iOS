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
#import "MLGMNavigationController.h"

@interface MLGMGenesViewController ()
@property (nonatomic, strong) NSArray *myGenes;

@end

@implementation MLGMGenesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Genes", @"");
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _myGenes = @[@"iOS---Objective-c", @"Android---Java"];
    
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
    self.navigationController.navigationBarHidden = NO;
    
    [self configureAddNewGeneButton];
}

- (void)configureAddNewGeneButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, self.view.bounds.size.height - 44 - 44, self.view.bounds.size.width, 44);
    btn.backgroundColor = BottomToolBarColor;
    [btn setTitle:NSLocalizedString(@"Add new gene", @"") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClickedAddNewGeneButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myGenes.count;
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

    NSString *genePair = _myGenes[indexPath.row];
    NSArray *skillAndLanguage = [genePair componentsSeparatedByString:@"---"];
    cell.textLabel.text = [skillAndLanguage firstObject];
    cell.detailTextLabel.text = [skillAndLanguage lastObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        MLGMAddNewGeneViewController *vcAddGene = [[MLGMAddNewGeneViewController alloc] init];
        [self.navigationController pushViewController:vcAddGene animated:YES];
    }
}

#pragma mark - Actions
- (void)onClickedEditGeneButton {
    [self presentAddNewGenePage];
}

- (void)onClickedAddNewGeneButton {
    [self presentAddNewGenePage];
}

- (void)presentAddNewGenePage {
    MLGMAddNewGeneViewController *addNewGeneVC = [[MLGMAddNewGeneViewController alloc] init];
    UINavigationController *nav = [[MLGMNavigationController alloc] initWithRootViewController:addNewGeneVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
