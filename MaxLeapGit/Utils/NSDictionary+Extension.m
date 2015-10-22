//
//  NSDictionary+QueryParameters.m
//  BSNShareCenter
//
//  Created by Jun Xia on 15/5/20.
//
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (NSString *)queryParameter {
    NSMutableArray *parameterPair = [NSMutableArray new];
    [self enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL *stop) {
        NSString *aPair;
        if (!value || [value isEqual:[NSNull null]]) {
            aPair = [field description].utf8AndURLEncode;
        } else {
            aPair = [NSString stringWithFormat:@"%@=%@", [field description].utf8AndURLEncode, [value description].utf8AndURLEncode];
        }
        [parameterPair addObject:aPair];
    }];
    
    return [parameterPair componentsJoinedByString:@"&"];
}

- (NSString *)jsonParameter {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!jsonData) {
        DDLogInfo(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for(NSString *key in self) {
        const id object = [self objectForKey:key];
        if(object == nul) {
            [replaced setObject:blank
                         forKey:key];
        }
    }
    
    return [replaced copy];
}

@end
