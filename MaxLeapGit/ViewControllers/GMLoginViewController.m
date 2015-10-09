//
//  GMLoginViewController.m
//  MaxLeapGit
//
//  Created by julie on 15/10/8.
//  Copyright © 2015年 iLegendsoft. All rights reserved.
//

#import "GMLoginViewController.h"
#import <WebKit/WebKit.h>

static NSString *const GITHUB_CALLBACK_URL  = @"https://github.com/";
static NSString *const GITHUB_CLIENT_ID     = @"f5df8209612826768527";
static NSString *const GITHUB_CLIENT_SECRET = @"3cce3f30d1c88bef1cb54f4caa09abeb64863112";

@interface GMLoginViewController () <WKNavigationDelegate>
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) void(^completionBlock)(BOOL succeeded);
@end

@implementation GMLoginViewController

- (instancetype)initWithCompletionBlock:(void(^)(BOOL succeeded))completionBlock {
    self = [super init];
    if (self) {
        _completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"GitHub Authorization", @"");
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancelLogin)];
    
    [self logIn];
}

- (void)logIn {
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20) configuration:webViewConfiguration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    NSString *scope = @"user,repo";
    NSString *requestURL = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@", GITHUB_CLIENT_ID, GITHUB_CALLBACK_URL, scope];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setTimeoutInterval:30];
    [self.webView loadRequest:request];
}

- (void)requestAccessTokenWithGrantCode:(NSString *)code {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code",
                               GITHUB_CLIENT_ID, @"client_id",
                               GITHUB_CALLBACK_URL, @"redirect_uri",
                               GITHUB_CLIENT_SECRET, @"client_secret", nil];
    NSString *paramString = [paramDict urlEncodedString];
    
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@",charset] forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && !connectionError) {
            NSError *jsonError = nil;
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if(jsonData && [NSJSONSerialization isValidJSONObject:jsonData]) {
                _accessToken = [jsonData objectForKey:@"access_token"];
#if DEBUG
                NSLog(@"accessToken = %@", _accessToken);
#endif
                if(_accessToken) {
                    if (_completionBlock) {
                        _completionBlock(YES);
                    }
                }
            }
        }
    }];
}

#pragma mark - Actions
- (void)cancelLogin {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSURLResponse *response = navigationResponse.response;
    NSString *responseURL = response.URL.absoluteString;
    NSLog(@"responseURL = %@", responseURL);
    NSString *prefixString = [GITHUB_CALLBACK_URL stringByAppendingString:@"?code="];
    if([responseURL hasPrefix:prefixString]) {
        NSString *code = [responseURL stringByReplacingOccurrencesOfString:prefixString withString:@""];
        [self requestAccessTokenWithGrantCode:code];
        if (decisionHandler) {
            decisionHandler(WKNavigationResponsePolicyCancel);
        }
        return;
    }
    
    if (decisionHandler) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

@end


static NSString *urlEncode(id object)
{
    NSString *string = [NSString stringWithFormat:@"%@", object];
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

@implementation NSDictionary (UrlEncoding)

-(NSString*) urlEncodedString
{
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self)
    {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

@end
