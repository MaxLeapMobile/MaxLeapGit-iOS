//  Copyright (c) 2012 Daniel Cutting. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSBundle (Extension)

- (id)jsonFromResource:(NSString *)resource;
- (id)plistObjectFromResource:(NSString *)resouce;
@end
