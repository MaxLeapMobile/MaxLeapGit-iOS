//
//  MLGMAuthViewController.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "MLGMAuthViewController.h"

/**
 * @see https://developer.github.com/v3/oauth/
 */

static NSString *const kGitHubAuthorizeURL = @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@";
static NSString *const kGitHubAccessTokenURL = @"https://github.com/login/oauth/access_token";
static NSString *const kScope = @"user,public_repo";

@interface MLGMAuthViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *rightButtomItem;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL isSetupConstraints;
@property (copy, nonatomic) void(^requestCodeSuccessHandler)(NSString *code, NSError *error);
@end

@implementation MLGMAuthViewController

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureNavigationBar];
    [self configureSubViews];
    [self updateViewConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAuthorizationCompletion:^(NSString *accessToken, NSError *error) {
        if (accessToken.length > 0) {
            if ([self.delegate respondsToSelector:@selector(authViewController:didReceiveAccessToken:)]) {
                [self.delegate authViewController:self didReceiveAccessToken:accessToken];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

#pragma mark- SubViews Configuration
- (void)configureNavigationBar {
    self.title = NSLocalizedString(@"Github Authorization", nil);
    self.navigationItem.rightBarButtonItem = self.rightButtomItem;
}

- (void)configureSubViews {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.activityIndicatorView];
}

#pragma mark- Action
- (void)rightButtomItemPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Public Method

#pragma mark- Private Method
- (void)clearWebViewCache {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showLoadingAnimation {
    [self.activityIndicatorView startAnimating];
}

- (void)dismissLoadingAnimation {
    [self.activityIndicatorView stopAnimating];
}

- (void)startAuthorizationCompletion:(void(^)(NSString *accessToken, NSError *error))completion {
    [self clearWebViewCache];
    [self requestCodeCompletion:^(NSString *code, NSError *error) {
        if (code.length >0 && error == nil) {
            [self exchangeAccessTokenWithCode:code completion:^(NSString *accessToken, NSError *error) {
                BLOCK_SAFE_ASY_RUN_MainQueue(completion, accessToken, nil);
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error", nil)];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
        }
    }];
}

- (void)requestCodeCompletion:(void (^)(NSString *code, NSError *error))completion {
    _requestCodeSuccessHandler = ^(NSString *code, NSError *error) {
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, code, error);
    };
    
    NSString *requestURLString = [NSString stringWithFormat:kGitHubAuthorizeURL, kGitHub_Client_ID, kGitHub_Redirect_URL, kScope];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURLString.toURL];
    [request setTimeoutInterval:30];
    [self.webView loadRequest:request];
}

- (void)exchangeAccessTokenWithCode:(NSString *)code
                         completion:(void(^)(NSString *accessToken, NSError *error))completion {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:kGitHubAccessTokenURL.toURL];
    NSDictionary *paramDict = @{@"code" : code,
                                @"client_id" : kGitHub_Client_ID,
                                @"client_secret" : KGitHub_Client_Secret,
                                @"redirect_uri" : kGitHub_Redirect_URL};
    NSString *paramString = [paramDict queryParameter];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
            return;
        }
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode == 200) {
            if (data.length > 0) {
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                if (!parseError && [responseDictionary isKindOfClass:[NSDictionary class]]) {
                    NSString *accessToken = responseDictionary[@"access_token"];
                    if (accessToken.length > 0) {
                        BLOCK_SAFE_ASY_RUN_MainQueue(completion, accessToken, nil);
                    } else {
                        NSError *error = [MLGMError errorWithCode:MLGMErrorTypeServerNotReturnDesiredData message:nil];
                        BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
                    }
                } else {
                    error = [MLGMError errorWithCode:MLGMErrorTypeServerDataFormateError message:nil];
                    BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
                }
            } else {
                error = [MLGMError errorWithCode:MLGMErrorTypeServerDataNil message:nil];
                BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
            }
        } else {
            error = [MLGMError errorWithCode:MLGMErrorTypeServerResponseError message:nil];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, error);
        }
    }];
    
    [sessionTask resume];
}

#pragma mark- Delegate，DataSource, Callback Method
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *responseURL = [request.URL absoluteString];
    NSString *prefixString = [kGitHub_Redirect_URL stringByAppendingString:@"?code="];
    if([responseURL hasPrefix:prefixString]) {
        NSString *code = [responseURL stringByReplacingOccurrencesOfString:prefixString withString:@""];
        BLOCK_SAFE_ASY_RUN_MainQueue(_requestCodeSuccessHandler, code, nil);
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadingAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self dismissLoadingAnimation];
}

#pragma mark- Override Parent Method
- (void)updateViewConstraints {
    if (!self.isSetupConstraints) {
        [self.webView pinToSuperviewEdges:JRTViewPinAllEdges inset:0.0f];
        [self.activityIndicatorView centerInContainer];
        
        self.isSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark- Getter Setter
- (UIBarButtonItem *)rightButtomItem {
    if (!_rightButtomItem) {
        _rightButtomItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(rightButtomItemPressed:)];
    }
    
    return _rightButtomItem;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [UIWebView autoLayoutView];
        _webView.delegate = self;
    }
    
    return _webView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _activityIndicatorView;
}

#pragma mark- Helper Method

@end
