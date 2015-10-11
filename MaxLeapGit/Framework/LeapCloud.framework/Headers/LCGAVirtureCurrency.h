//
//  LCGAVirtureCurrency.h
//  LeapCloud
//
//  Created by Sun Jin on 6/23/15.
//  Copyright (c) 2015 leap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface LCGAVirtureCurrency : NSObject

+ (void)onChargeRequest:(SKPaymentTransaction *)transaction
                orderId:(NSString *)orderId
         currencyAmount:(double)currencyAmount
           currencyType:(NSString *)currencyType
  virtualCurrencyAmount:(double)virtualCurrencyAmount
              paySource:(NSString *)paySource;

+ (void)onChargeSuccess:(SKPaymentTransaction *)transaction orderId:(NSString *)orderId;
+ (void)onChargeCancelled:(SKPaymentTransaction *)transaction orderId:(NSString *)orderId;
+ (void)onChargeFailed:(SKPaymentTransaction *)transaction orderId:(NSString *)orderId;

+ (void)onReward:(double)virtualCurrencyAmount reason:(NSString *)reason;

@end
