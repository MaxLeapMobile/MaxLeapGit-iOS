//
//  LCReceiptManager.h
//  LeapCloud
//
//  Created by Sun Jin on 15/3/10.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCConstants.h>
#else
    #import <LeapCloud/LCConstants.h>
#endif

/**
 * LCReceiptManager
 */
@interface LCReceiptManager : NSObject

/*!
 @discussion LeapCloud validates the receipt with Apple and gives the result.
 
 @code
 NSData *receipt = transaction.transactionReceipt;
 
 [LCReceiptManager verifyPaymentReceipt:receipt completion:^(BOOL isValid, NSError *error) {
    if (isValid) {
        // the receipt is valid
    } else {
        // The receipt validating failed.
        if ([error.domain isEqualToString:LCErrorDomain] && error.code == kLCErrorInvalidAuthData) {
            // the receipt is invalid
        } else {
            // an error occured
        }
    }
 }];
 @endcode
 
 @param receiptData The receipt data contained in a transaction.
 @param block the completion block will excute on main thread.
 */
+ (void)verifyPaymentReceipt:(NSData *)receiptData completion:(LCBooleanResultBlock)block;

@end
