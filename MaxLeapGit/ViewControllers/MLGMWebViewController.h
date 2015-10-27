//
//  MLGMWebViewController.h
//  MaxLeapGit
//
//  Created by Julie on 15/10/14.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface MLGMWebViewController : UIViewController
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *url;
@end
