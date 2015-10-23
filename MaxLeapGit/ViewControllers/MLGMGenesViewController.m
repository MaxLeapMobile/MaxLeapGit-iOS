//
//  GMGenesViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMGenesViewController.h"


@interface MLGMGenesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *genes;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *geneCreationButton;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MLGMGenesViewController
#pragma mark - init Method

#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubViews];
    
    [self reloadData];
}

- (void)reloadData {
    self.genes = [NSMutableArray arrayWithArray:[kOnlineAccountProfile.genes allObjects]];
    [self.genes sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updateTime" ascending:NO]]];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self transparentNavigationBar:NO];
    [self reloadData];
}

#pragma mark- Override Parent Method
- (void)updateViewConstraints {
    if (!_didSetupConstraints) {
        [self.tableView pinToSuperviewEdges:JRTViewPinTopEdge | JRTViewPinLeftEdge | JRTViewPinRightEdge inset:0.0f];
        [self.tableView pinAttribute:NSLayoutAttributeBottom toAttribute:NSLayoutAttributeTop ofItem:self.geneCreationButton];
        [self.geneCreationButton pinToSuperviewEdges:JRTViewPinLeftEdge | JRTViewPinRightEdge | JRTViewPinBottomEdge inset:0.0];
        [self.geneCreationButton constrainToHeight:44];
        
        _didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark- SubView Configuration
- (void)configureSubViews {
    self.title = NSLocalizedString(@"Genes", @"");
    [self.view addSubview:self.geneCreationButton];
    [self.view addSubview:self.tableView];
}

#pragma mark- Action
- (void)editGene:(MLGMGene *)gene {
    [self presentNewGeneViewControllerWithGene:gene];
}

- (void)onClickedAddNewGeneButton {
    [self presentNewGeneViewControllerWithGene:nil];
}

- (void)presentNewGeneViewControllerWithGene:(MLGMGene *)gene {
    MLGMNewGeneViewController *geneCreationVC = [[MLGMNewGeneViewController alloc] init];
    geneCreationVC.gene = gene;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:geneCreationVC];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark- Delegate，DataSource, Callback Method
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.genes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLGMGeneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLGMGeneCell"];
    MLGMGene *gene = self.genes[indexPath.row];
    cell.editingButtonEventHandler = ^(MLGMGene *gene) {
        [self editGene:gene];
    };
    
    [cell configureCell:gene];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MLGMGene *gene = self.genes[indexPath.row];
        [self.genes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [gene MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        [KSharedWebService syncOnlineAccountGenesToMaxLeapCompletion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- Private Method

#pragma mark- Getter Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView autoLayoutView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[MLGMGeneCell class] forCellReuseIdentifier:@"MLGMGeneCell"];
    }
    
    return _tableView;
}

- (UIButton *)geneCreationButton {
    if (!_geneCreationButton) {
        _geneCreationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _geneCreationButton.frame = CGRectMake(0, self.view.bounds.size.height - 64 - 44, self.view.bounds.size.width, 44);
        _geneCreationButton.backgroundColor = BottomToolBarColor;
        [_geneCreationButton setTitle:NSLocalizedString(@"Add new gene", @"") forState:UIControlStateNormal];
        [_geneCreationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _geneCreationButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_geneCreationButton addTarget:self action:@selector(onClickedAddNewGeneButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _geneCreationButton;
}

#pragma mark- Helper Method
@end
