//
//  LCGAItem.h
//  LeapCloud
//
//  Created by Sun Jin on 6/24/15.
//  Copyright (c) 2015 leap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCGAItem : NSObject

+ (void)onPurchase:(NSString *)item itemCount:(int)count itemType:(NSString *)type virtualCurrency:(double)virtualCurrencyAmount;

+ (void)onUse:(NSString *)item itemType:(NSString *)type itemCount:(int)count;

+ (void)onReward:(NSString *)item itemType:(NSString *)itemType itemCount:(int)count reason:(NSString *)reason;

@end
