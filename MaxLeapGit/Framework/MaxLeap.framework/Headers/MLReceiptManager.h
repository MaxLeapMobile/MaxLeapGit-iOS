//
//  MLReceiptManager.h
//  MaxLeap
//
//  Created by Sun Jin on 15/3/10.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <MaxLeapExt/MLConstants.h>
#else
    #import <MaxLeap/MLConstants.h>
#endif

/**
 * MLReceiptManager
 */
@interface MLReceiptManager : NSObject

/*!
 @discussion MaxLeap validates the receipt with Apple and gives the result.
 
 @code
 NSData *receipt = transaction.transactionReceipt;
 
 [MLReceiptManager verifyPaymentReceipt:receipt completion:^(BOOL isValid, NSError *error) {
    if (isValid) {
        // the receipt is valid
    } else {
        // The receipt validating failed.
        if ([error.domain isEqualToString:MLErrorDomain] && error.code == kMLErrorInvalidAuthData) {
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
+ (void)verifyPaymentReceipt:(NSData *)receiptData completion:(MLBooleanResultBlock)block;

@end
