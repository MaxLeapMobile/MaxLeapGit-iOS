//
//  LCCloudCode.h
//  LeapCloud
//
//  Created by Sun Jin on 10/13/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCConstants.h>
#else
    #import <LeapCloud/LCConstants.h>
#endif

/*!
 The `LCCloudCode` class provides methods for interacting with LeapCloud Functions.
 */
@interface LCCloudCode : NSObject

/*!
 Calls the given cloud function with the parameters provided asynchronously and calls the given block when it is done.
 @param function The function name to call.
 @param parameters The parameters to send to the function.
 @param block The block to execute. The block should have the following argument signature:(id object, NSError *error).
 */
+ (void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)parameters block:(LCIdResultBlock)block;

@end
