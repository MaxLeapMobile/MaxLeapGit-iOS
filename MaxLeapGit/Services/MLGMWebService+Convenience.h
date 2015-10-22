//
//  MLGMWebService+Convenience.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/10.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMWebService.h"

typedef void(^CompleteHanderBlock)(NSDictionary *responHeaderFields, NSInteger statusCode, id responseData, NSError *error);

@interface MLGMWebService (Convenience)
- (NSURLRequest *)getRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)queryParameters;
- (NSURLRequest *)postRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)postParameters;
- (NSURLRequest *)putRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)postParameters;
- (NSURLRequest *)deleteRequestWithEndPoint:(NSString *)endPoint parameters:(NSDictionary *)postParameters;

- (void)startRquest:(NSURLRequest *)request patternFile:(NSString *)patternFile completion:(CompleteHanderBlock)completion;
- (void)cancelAllDataTasksCompletion:(void(^)())completion;

- (JSONValidation *)jsonValidation;

@end
