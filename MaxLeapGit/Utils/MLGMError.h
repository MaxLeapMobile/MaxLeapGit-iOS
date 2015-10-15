//
//  MLGMError.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MLGMErrorType) {
    MLGMErrorTypeDefault,
    MLGMErrorTypeServerNotReturnDesiredData = 1000,
    MLGMErrorTypeServerDataFormateError,
    MLGMErrorTypeServerDataNil,
    MLGMErrorTypeServerResponseError,
    MLGMErrorTypeBadCredentials,
    MLGMErrorTypeNoOnlineAccount
};

@interface MLGMError : NSError
+ (NSError *)errorWithCode:(MLGMErrorType)errorType message:(NSString *)message;
@end
