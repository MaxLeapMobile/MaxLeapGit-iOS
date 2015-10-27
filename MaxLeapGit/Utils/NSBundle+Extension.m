//  Copyright (c) 2012 Daniel Cutting. All rights reserved.

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

- (id)jsonFromResource:(NSString *)resource {
    NSString *path = [self pathForResource:resource ofType:nil];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    if (!jsonData.length) {
        return nil;
    }
    
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        DDLogError(@"resolve text file to json object error:%@", error.description);
    }
    
    if (!json) {
        return nil;
    }
    
    return json;
}

- (id)plistObjectFromResource:(NSString *)resource {
    NSString *path = [self pathForResource:resource ofType:nil];
    NSData *plistData = [NSData dataWithContentsOfFile:path];
    if (!plistData.length) {
        return nil;
    }
    
    NSError *error;
    NSPropertyListFormat format;
    NSDictionary* plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&format error:&error];
    if (error) {
        DDLogError(@"resolve plist file error:%@", error.description);
    }
    
    return plist;
}

@end
