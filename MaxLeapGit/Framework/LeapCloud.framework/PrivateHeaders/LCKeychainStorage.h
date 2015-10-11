//
//  LCKeychainStorage.h
//  LeapCloud
//
//  Created by Sun Jin on 15/2/3.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCKeychainStorage : NSObject

+ (instancetype)standardStorage;
+ (instancetype)generalPasteboard;

+ (instancetype)storageWithIdentifier:(NSString *)identifier;
+ (instancetype)storageWithIdentifier:(NSString *)identifier group:(NSString *)group;

- (id)objectForKey:(NSString *)aKey;
- (void)setObject:(id)value forKey:(NSString *)aKey;
- (void)removeObjectForKey:(NSString *)aKey;

- (void)synchronize;

@end
