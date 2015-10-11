//  Copyright (c) 2012 Daniel Cutting. All rights reserved.

#import "JSONValidation.h"
#include <float.h>

NSString *VeriJSONErrorDomain = @"VeriJSONErrorDomain";

@implementation JSONValidation

- (BOOL)verifyJSON:(id)json pattern:(id)pattern {
    return [self verifyJSON:json pattern:pattern error:NULL];
}

- (BOOL)verifyJSON:(id)json pattern:(id)pattern error:(NSError **)error {
    if (!pattern) return YES;
    if (!json) return NO;
    
    NSMutableArray *patternStack = [NSMutableArray arrayWithObject:@""];    // Root element.
    BOOL valid = [self verifyValue:json pattern:pattern permitNull:NO patternStack:patternStack];
    if (!valid && error) {
        *error = [self buildErrorFromPatternStack:patternStack];
    }
    return valid;
}

- (BOOL)verifyValue:(id)value pattern:(id)pattern permitNull:(BOOL)permitNull patternStack:(NSMutableArray *)patternStack {
    if (permitNull && [value isKindOfClass:[NSNull class]]) return YES;

    if ([pattern isKindOfClass:[NSDictionary class]]) {
        return [self verifyObject:value pattern:pattern patternStack:patternStack];
    } else if ([pattern isKindOfClass:[NSArray class]]) {
        return [self verifyArray:value pattern:pattern patternStack:patternStack];
    }
    return [self verifyBaseValue:value pattern:pattern patternStack:patternStack];
}

- (BOOL)verifyObject:(NSDictionary *)object pattern:(NSDictionary *)objectPattern patternStack:(NSMutableArray *)patternStack {
    if (![object isKindOfClass:[NSDictionary class]]) return NO;
    __block BOOL valid = YES;
    [objectPattern enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, id attributePattern, BOOL *stop) {
        [patternStack addObject:attributeName];
        BOOL attributeValid = [self verifyObject:object attributeName:attributeName attributePattern:attributePattern patternStack:patternStack];
        if (attributeValid) {
            [patternStack removeLastObject];
        } else {
            valid = NO;
            *stop = YES;
        }
    }];
    return valid;
}
 
- (BOOL)verifyObject:(NSDictionary *)object attributeName:(NSString *)attributeName attributePattern:(id)attributePattern patternStack:(NSMutableArray *)patternStack {
    BOOL isOptional = [self isOptionalAttribute:attributeName];
    NSString *strippedAttributeName = [self strippedAttributeName:attributeName];
    id value = [object objectForKey:strippedAttributeName];
    if (value) {
        return [self verifyValue:value pattern:attributePattern permitNull:isOptional patternStack:patternStack];
    }
    return isOptional;
}

- (NSString *)strippedAttributeName:(NSString *)attributeName {
    if ([self isOptionalAttribute:attributeName]) {
        return [attributeName substringToIndex:[attributeName length] - 1];
    }
    return attributeName;
}

- (BOOL)isOptionalAttribute:(NSString *)attributeName {
    return [attributeName hasSuffix:@"?"];
}

- (BOOL)verifyArray:(NSArray *)array pattern:(NSArray *)arrayPattern patternStack:(NSMutableArray *)patternStack {
    if (![array isKindOfClass:[NSArray class]]) return NO;
    __block BOOL valid = YES;

    if ([arrayPattern count] == 0) {
        return YES; // Pattern is empty array. It accepts any size of array.
    } else if ([array count] == 0) {
        return YES; //Pattern is not empty. empty array return YES.
    }
    //Here, both array Pattern and array are not empty
    id valuePattern = [arrayPattern objectAtIndex:0];
    [array enumerateObjectsUsingBlock:^(id value, NSUInteger idx, BOOL *stop) {
        if (![self verifyValue:value pattern:valuePattern permitNull:NO patternStack:patternStack]) {
            valid = NO;
            *stop = YES;
        }
    }];
    return valid;
}

- (BOOL)verifyBaseValue:(id)value pattern:(id)pattern patternStack:(NSMutableArray *)patternStack {
    [patternStack addObject:pattern];
    
    BOOL valid = NO;

    if ([@"string" isEqualToString:pattern] || [pattern hasPrefix:@"string:"]) {
        valid = [self verifyString:value pattern:pattern];
    }
    else if ([@"number" isEqualToString:pattern] || [pattern hasPrefix:@"number:"] ) {
        valid = [value isKindOfClass:[NSNumber class]];
        if (valid) {
          valid = [self verifyNumber:value pattern:pattern];
        }
    }
    else if ([@"int" isEqualToString:pattern] || [pattern hasPrefix:@"int:"] ) {
        valid = [value isKindOfClass:[NSNumber class]] && [self isNumberFromInt:value];
        if (valid) {
            valid = [self verifyNumber:value pattern:pattern];
        }
    }
    else if ([@"bool" isEqualToString:pattern]) {
        valid = [value isKindOfClass:[NSNumber class]];
    }
    else if ([@"url" isEqualToString:pattern]) {
        valid = [self verifyURL:value];
    }
    else if ([@"url:http" isEqualToString:pattern]) {
        valid = [self verifyHTTPURL:value];
    }
    else if ([@"email" isEqualToString:pattern]) {
        valid = [self verifyEmail:value];
    }
    else if ([@"color" isEqualToString:pattern]) {
        valid = [self verifyColor:value];
    }
    else if ([@"*" isEqualToString:pattern]) {
        //any base data type
        valid = ![value isKindOfClass:[NSArray class]] && ![value isKindOfClass:[NSDictionary class]];
    }
    else if ([pattern hasPrefix:@"["]) {
        //Multipal types. Only support basic type names. Doesn't support regular expression completely. 
        pattern = [pattern stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\n\r]["]];
        NSArray* types = [pattern componentsSeparatedByString:@"|"];
        for (NSString* type in types) {
            valid = [self verifyBaseValue:value pattern:type patternStack:patternStack];
            if (valid) break;
        }
    }
    
    if (valid) {
        [patternStack removeLastObject];
    }
    return valid;
}

- (BOOL) isNumberFromInt:(NSNumber*) value {
    CFNumberType numberType = CFNumberGetType((CFNumberRef)value);
    return numberType == kCFNumberSInt8Type
    || numberType == kCFNumberSInt16Type
    || numberType == kCFNumberSInt32Type
    || numberType == kCFNumberSInt64Type
    || numberType == kCFNumberLongType
    || numberType == kCFNumberLongLongType;
}

- (BOOL)verifyNumber:(NSNumber*) value pattern:(NSString*) pattern {
    
    BOOL valid = YES;
    NSArray *components = [pattern componentsSeparatedByString:@":"];
    if ([components count] < 2) return valid;
    
    
    NSString* range = [components objectAtIndex:1];
    range = [range stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray*  rangeValues = [range componentsSeparatedByString:@","];
    if ([rangeValues count] == 2) {
        
        NSString* minStr = [rangeValues objectAtIndex:0];
        NSString* maxStr = [rangeValues objectAtIndex:1];
        
        float min;
        if ([minStr length] == 0) {
            min = -FLT_MAX;
        } else {
            min = [minStr floatValue];
        }
        
        float max;
        if ([maxStr length] == 0) {
            max = FLT_MAX;
        } else {
            max = [maxStr floatValue];
        }
        
        valid = min <= [value floatValue] && max >= [value floatValue];
        
    }
    return valid;
}

- (BOOL)verifyString:(NSString *)value pattern:(NSString *)pattern {
    if (![value isKindOfClass:[NSString class]]) return NO;
    NSArray *components = [pattern componentsSeparatedByString:@":"];
    if ([components count] > 1) {
        NSString *regexPattern = [components objectAtIndex:1];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:0 error:NULL];
        NSUInteger numMatches = [regex numberOfMatchesInString:value options:NSMatchingReportCompletion range:NSMakeRange(0, [value length])];
        return numMatches > 0;
    }
    return YES;
}

- (BOOL)verifyURL:(id)value {
    return nil != [self urlFromValue:value];
}

- (BOOL)verifyHTTPURL:(id)value {
    NSURL *url = [self urlFromValue:value];
    NSString *scheme = [[url scheme] lowercaseString];
    NSString *host = [url host];
    return ([scheme isEqualToString:@"https"] || [scheme isEqualToString:@"http"]) && [host length] > 0 ;
}

- (BOOL) verifyEmail: (NSString *) value {
    NSString *emailRegex = @"[^@\\s]+@[^.@\\s]+(\\.[^.@\\s]+)+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:value];
}

- (BOOL) verifyColor: (id)value {
    UIColor *color = nil;
    if ([value isKindOfClass:NSString.class]) {
        //hex string
        color = [self colorWithHexString:(NSString*)value];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {

        long code = [(NSNumber*)value longValue];
        
        if (code >= 0 && code <= 0xFFFFFF) {

            int red = (code >> 16) & 0x000000FF;
            int green = (code >> 8) & 0x000000FF;
            int blue = (code) & 0x000000FF;
            color =  [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
        }
    }
    BOOL valid = (color != nil);
    return valid;
}

//The hex strign can have 0X or Ox prefix.
- (UIColor*) colorWithHexString:(NSString*) hex {
    
    if ([hex hasPrefix:@"0x"] || [hex hasPrefix:@"0X"] ) {
        hex = [hex stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
    }
    
    if ([hex length]!=6)
    {
        return nil;
    }
    
    CGFloat red = [self integerValueFromHex:[hex substringWithRange:NSMakeRange(0, 2)]]/255.0;
    CGFloat green = [self integerValueFromHex:[hex substringWithRange:NSMakeRange(2, 2)]]/255.0;
    CGFloat blue = [self integerValueFromHex:[hex substringWithRange:NSMakeRange(4, 2)]]/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (NSUInteger)integerValueFromHex:(NSString*) hexString
{
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned int result = 0;
    [scanner scanHexInt: &result];
    
    return result;
}

- (NSURL *)urlFromValue:(id)value {
    if (![value isKindOfClass:[NSString class]]) return nil;
    NSString *trimmedValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (0 == [trimmedValue length]) return nil;
    return [NSURL URLWithString:value];
}

- (NSError *)buildErrorFromPatternStack:(NSArray *)patternStack {
    NSString *path = [self buildPathFromPatternStack:patternStack];
    NSString *localisedDescription = [NSString stringWithFormat:@"Invalid pattern %@", path];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:localisedDescription, NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:VeriJSONErrorDomain code:VeriJSONErrorCodeInvalidPattern userInfo:userInfo];
}

- (NSString *)buildPathFromPatternStack:(NSArray *)patternStack {
    return [patternStack componentsJoinedByString:@"."];
}

@end
