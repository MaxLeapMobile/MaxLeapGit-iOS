//
//  MLGMError.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/9.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MLGMErrorType) {
    MLGMErrorTypeDefault,
    MLGMErrorTypeServerNotReturnDesiredData,
    MLGMErrorTypeServerDataFormateError,
    MLGMErrorTypeServerDataNil,
    MLGMErrorTypeServerResponseError,
    MLGMErrorTypeBadCredentials
};

@interface MLGMError : NSError
+ (NSError *)errorWithCode:(MLGMErrorType)errorType message:(NSString *)message;
@end