//
//  UITableViewCell+Extension.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/14.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)
- (UITableView *)tableView {
    UITableView *tableView = (UITableView*)self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView != nil) {
        tableView = (UITableView*)tableView.superview;
    }
    
    return tableView;
}

@end
