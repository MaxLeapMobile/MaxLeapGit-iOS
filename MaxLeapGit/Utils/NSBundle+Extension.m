//  Copyright (c) 2012 Daniel Cutting. All rights reserved.

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

- (id)jsonFromResource:(NSString *)resource {
    NSString *path = [self pathForResource:resource ofType:nil];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    if (!jsonData.length) {
        return nil;
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    if (!json) {
        return nil;
    }
    
    return json;
}

@end
