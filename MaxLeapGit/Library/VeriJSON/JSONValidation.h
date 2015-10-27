//  Copyright (c) 2012 Daniel Cutting. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *VeriJSONErrorDomain;

typedef enum {
    VeriJSONErrorCodeInvalidPattern
} VeriJSONErrorCode;

@interface JSONValidation : NSObject

- (BOOL)verifyJSON:(id)json pattern:(id)pattern;
- (BOOL)verifyJSON:(id)json pattern:(id)pattern error:(NSError **)error;

@end
