//
//  MLGMWebService+Convenience.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/10.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMWebService+Convenience.h"

#define kTimeOutInvervalForRequest 30

static NSString *const kGitHubBaseName = @"https://api.github.com";
typedef void(^SessionrResponse)(NSInteger statusCode, NSData *receiveData, NSError *error);

@implementation MLGMWebService (Convenience)

- (NSString *)accessToken {
    MLGMAccount *account = [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES)];
    return account.accessToken;
}

- (NSURLRequest *)getRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)queryParameters {
    NSString *requestURLString = [NSString stringWithFormat:@"%@%@", kGitHubBaseName, endPoint];
    if (queryParameters) {
        requestURLString = [requestURLString stringByAppendingFormat:@"?%@", queryParameters.queryParameter];
    }
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    request.timeoutInterval = kTimeOutInvervalForRequest;
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *accessToken = [self accessToken];
    if (accessToken.length > 0) {
        [request setValue:[NSString stringWithFormat:@"token %@", accessToken] forHTTPHeaderField:@"Authorization"];
    }
    
    return request;
}

- (NSURLRequest *)postRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)postParameters {
    NSString *requestURLString = [NSString stringWithFormat:@"%@%@", kGitHubBaseName, endPoint];
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.timeoutInterval = kTimeOutInvervalForRequest;
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *accessToken = [self accessToken];
    if (accessToken.length > 0) {
        [request setValue:[NSString stringWithFormat:@"token %@", accessToken] forHTTPHeaderField:@"Authorization"];
    }
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [postParameters.jsonParameter dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    return request;
}

- (NSURLRequest *)putRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)postParameters {
    NSString *requestURLString = [NSString stringWithFormat:@"%@%@", kGitHubBaseName, endPoint];
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.timeoutInterval = kTimeOutInvervalForRequest;
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    
    NSString *accessToken = [self accessToken];
    if (accessToken.length > 0) {
        [request setValue:[NSString stringWithFormat:@"token %@", accessToken] forHTTPHeaderField:@"Authorization"];
    }
    
    [request setHTTPMethod:@"PUT"];
    NSData *postData = [postParameters.jsonParameter dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    return request;
}

- (NSURLRequest *)deleteRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)postParameters {
    NSString *requestURLString = [NSString stringWithFormat:@"%@%@", kGitHubBaseName, endPoint];
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.timeoutInterval = kTimeOutInvervalForRequest;
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *accessToken = [self accessToken];
    if (accessToken.length > 0) {
        [request setValue:[NSString stringWithFormat:@"token %@", accessToken] forHTTPHeaderField:@"Authorization"];
    }
    
    [request setHTTPMethod:@"DELETE"];
    NSData *postData = [postParameters.jsonParameter dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    return request;
}

- (void)startRquest:(NSURLRequest *)request patternFile:(NSString *)patternFile completion:(CompleteHanderBlock)completion {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData *receiveData, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (error) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, statusCode, nil, error);
            return;
        }
        
        if (statusCode == 401) {
            error = [MLGMError errorWithCode:MLGMErrorTypeBadCredentials message:nil];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, statusCode, nil, error);
            return;
        }
        
        if (statusCode == 304) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, statusCode, nil, nil);
            return;
        }
        
        if (statusCode != 200) {
            NSString *errorMessage;
            if (receiveData.length > 0) {
                errorMessage = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
            } else {
                errorMessage = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
            }
            error = [MLGMError errorWithCode:MLGMErrorTypeServerResponseError message:errorMessage];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, statusCode, nil, error);
            return;
        }
        
        if (receiveData.length == 0) {
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, statusCode, nil, nil);
            return;
        }
        
        NSError *parseError = nil;
        id responseObject = [NSJSONSerialization JSONObjectWithData:receiveData options:0 error:&parseError];
        if (parseError) {
            NSString *errorMessage = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
            NSError *error = [MLGMError errorWithCode:MLGMErrorTypeServerDataFormateError message:errorMessage];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, statusCode, nil, error);
            return;
        }
        
        id pattern = [[NSBundle mainBundle] jsonFromResource:patternFile];
        BOOL valid = [self.jsonValidation verifyJSON:responseObject pattern:pattern];
        if (!valid) {
            NSString *receiveDataString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
            NSString *errorMessage = [NSString stringWithFormat:@"server data formate invalid,content:<%@>", receiveDataString];
            error = [MLGMError errorWithCode:MLGMErrorTypeServerDataFormateError message:errorMessage];
            BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil, statusCode, nil, error);
            return;
        }
        
        NSDictionary *responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, responseHeaderFields, statusCode, responseObject, nil);
    }];
    
    [sessionTask resume];
}

- (void)cancelAllDataTasksCompletion:(void(^)())completion {
    [[NSURLSession sharedSession] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        [dataTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask *oneDataTask, NSUInteger idx, BOOL *stop) {
            if (oneDataTask.state == NSURLSessionTaskStateRunning) {
                [oneDataTask cancel];
            }
        }];
        BLOCK_SAFE_ASY_RUN_MainQueue(completion, nil);
    }];
}

- (JSONValidation *)jsonValidation {
    static JSONValidation *jsonValidation = nil;
    if (!jsonValidation) {
        jsonValidation = [JSONValidation new];
    }
    
    return jsonValidation;
}

@end
