//
//  MLGMWebViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/14.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMWebViewController.h"
#import <WebKit/WebKit.h>
#import "MLGMTabBarController.h"

#define kWebViewLoadingStatusKey       @"loading"
#define kWebViewLoadingProgressKey     @"estimatedProgress"

@interface MLGMWebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation MLGMWebViewController

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:kWebViewLoadingStatusKey];
    [_webView removeObserver:self forKeyPath:kWebViewLoadingProgressKey];
    _webView.navigationDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_url.length) {
        NSArray *array = [_url componentsSeparatedByString:@"/"];
        self.title = [array lastObject];
    }
    
    [(MLGMTabBarController *)self.navigationController.tabBarController setTabBarHidden:YES];
   
    [self configureWebView];
    [self configureProgressView];
}

- (void)configureProgressView {
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
    _progressView.progressTintColor = [UIColor greenColor];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressView.progress = 0;
    [self.view addSubview:_progressView];
}

- (void)configureWebView {
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) configuration:webViewConfiguration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    //observe loading progress
    [_webView addObserver:self forKeyPath:kWebViewLoadingStatusKey options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:kWebViewLoadingProgressKey options:NSKeyValueObservingOptionNew context:nil];
    
    if (_url.length) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        [self.webView loadRequest:request];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kWebViewLoadingStatusKey]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = _webView.loading;
    } else if ([keyPath isEqualToString:kWebViewLoadingProgressKey]) {
        _progressView.hidden = NO;
        [_progressView setProgress:_webView.estimatedProgress animated:YES];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    _progressView.progress = 0;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = webView.loading;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    _progressView.progress = 1;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        _progressView.progress = 0;  //reset the value of the progress view when loading is complete
        _progressView.hidden = YES;
    });
}

@end
