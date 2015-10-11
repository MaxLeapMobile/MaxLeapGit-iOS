//
//  NSString+Extension.m
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/10.
//  Copyright © 2015年 MaxLeap. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (MFLMExtension)

+ (NSString *)getUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return uuidStr;
}

+ (NSString *)getNonce {
    NSString *uuid = [self getUUID];
    return [[uuid substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@""].lowercaseString;
}

- (NSString *)utf8AndURLEncode {
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSDictionary *)parametersFromQueryString {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self) {
        NSScanner *parameterScanner = [[NSScanner alloc] initWithString:self];
        NSString *name = nil;
        NSString *value = nil;
        
        while (![parameterScanner isAtEnd]) {
            name = nil;
            [parameterScanner scanUpToString:@"=" intoString:&name];
            [parameterScanner scanString:@"=" intoString:NULL];
            
            value = nil;
            [parameterScanner scanUpToString:@"&" intoString:&value];
            [parameterScanner scanString:@"&" intoString:NULL];
            
            if (name && value)
            {
                [parameters setValue:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              forKey:[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    
    return parameters;
}

- (NSString *)removeNonAsciiCharacter {
    NSMutableString *asciiCharacters = [NSMutableString string];
    for (NSInteger i = 32; i < 127; i++)  {
        [asciiCharacters appendFormat:@"%c", (char)i];
    }
    
    NSCharacterSet *nonAsciiCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:asciiCharacters] invertedSet];
    
    NSString *stringExcuteNonAscii = [[self componentsSeparatedByCharactersInSet:nonAsciiCharacterSet] componentsJoinedByString:@""];
    
    return stringExcuteNonAscii;
}

- (NSDate *)toDate {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    }
    
    return [dateFormatter dateFromString:self];
}

- (NSUInteger)toAge {
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:self.toDate
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    
    return age;
}

- (NSURL *)toURL {
    return [NSURL URLWithString:self];
}

+ (NSString *)uuid {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    if (!uuid.length) {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
        uuid = [@(timeInterval) stringValue];
        [[NSUserDefaults standardUserDefaults] setObject:uuid  forKey:@"uuid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return uuid;
}

- (float)heightInFixedWidth:(CGFloat)fixedWidth andFont:(UIFont *)font lineSpace:(float)lineSpace {
    if (self.length) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpace;
        CGRect frame = [self boundingRectWithSize:CGSizeMake(fixedWidth, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName : paragraphStyle}
                                          context:nil];
        return frame.size.height + 1;
    } else {
        return 0;
    }
}

@end
