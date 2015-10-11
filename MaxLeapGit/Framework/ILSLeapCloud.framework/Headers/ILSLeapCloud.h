//
//  ILSLeapCloud.h
//  ILSLeapCloud
//
//  Created by Sun Jin on 8/25/15.
//  Copyright (c) 2015 leap. All rights reserved.
//

#import <LeapCloud/LeapCloud.h>
#import <ILSLeapCloud/MethodSwizzler.h>
#import <ILSLeapCloud/LCSdkService.h>
#import <ILSLeapCloud/LCSdkServiceManager.h>

@interface ILSLeapCloud : NSObject

+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;

@end

