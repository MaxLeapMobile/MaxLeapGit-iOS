//
//  NSString+Extension.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/10.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
+ (NSString *)uuid;
+ (NSString *)getNonce;
- (NSDictionary *)parametersFromQueryString;
- (NSString *)utf8AndURLEncode;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)removeNonAsciiCharacter;
- (NSDate *)toDate;
- (NSUInteger)toAge;
- (NSURL *)toURL;

- (float)heightInFixedWidth:(CGFloat)fixedWidth andFont:(UIFont *)font lineSpace:(float)lineSpace;
@end
