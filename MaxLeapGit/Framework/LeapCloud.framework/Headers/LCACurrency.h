//
//  LCACurrency.h
//  LeapCloud
//
//  Created by Sun Jin on 6/23/15.
//  Copyright (c) 2015 leap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SKPaymentTransaction;

@interface LCACurrency : NSObject

+ (void)onPurchaseRequest:(SKPaymentTransaction *)transaction isSubscription:(BOOL)isSubscription;
+ (void)onPurchaseSuccess:(SKPaymentTransaction *)transaction isSubscription:(BOOL)isSubscription;
+ (void)onPurchaseCancelled:(SKPaymentTransaction *)transaction isSubscription:(BOOL)isSubscription;
+ (void)onPurchaseFailed:(SKPaymentTransaction *)transaction isSubscription:(BOOL)isSubscription;

@end
