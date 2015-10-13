//
//  MLGMError.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import "MLGMError.h"

NSString* const MLGMErrorDomain = @"MFLMErrorDomain";

@implementation MLGMError

+ (NSError *)errorWithCode:(MLGMErrorType)errorType message:(NSString *)message {
    NSError *error;
    
    if (message.length > 0) {
        error = [NSError errorWithDomain:MLGMErrorDomain
                                    code:errorType
                                userInfo:@{NSLocalizedDescriptionKey:SAFE_STRING(message)}];
    } else {
        message = NSLocalizedString(@"error", nil);
        switch (errorType) {
            case MLGMErrorTypeServerDataNil:
                message = NSLocalizedString(@"服务器返回数据为空", nil);
                break;
            case MLGMErrorTypeServerDataFormateError:
                message = NSLocalizedString(@"服务器返回数据格式不正确", nil);
                break;
            case MLGMErrorTypeServerResponseError:
                message = NSLocalizedString(@"请求响应失败", nil);
                break;
            case MLGMErrorTypeServerNotReturnDesiredData:
                message = NSLocalizedString(@"服务器没有返回期望的数据", nil);
                break;
            case MLGMErrorTypeBadCredentials:
                message = NSLocalizedString(@"非法Access Token", nil);
                break;
            case MLGMErrorTypeNoOnlineAccount:
                message = NSLocalizedString(@"没有登录的账号", nil);
                break;
            default:
                break;
        }
        error = [NSError errorWithDomain:MLGMErrorDomain code:errorType userInfo:@{NSLocalizedDescriptionKey:SAFE_STRING(message)}];
    }
    
    return error;
}

@end
