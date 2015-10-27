//
//  MLGMOrganizationDetailController.m
//  MaxLeapGit
//
//  Created by Julie on 15/10/27.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMOrganizationDetailController.h"

@interface MLGMOrganizationDetailController ()

@end

@implementation MLGMOrganizationDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.url.length) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url.toURL]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
