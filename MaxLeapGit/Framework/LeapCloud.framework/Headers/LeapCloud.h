//
//  LeapCloud.h
//  LeapCloud
//
//  Created by Sun Jin on 6/23/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <LeapCloud/LCConstants.h>
#import <LeapCloud/LCRelation.h>
#import <LeapCloud/LCACL.h>
#import <LeapCloud/LCGeoPoint.h>
#import <LeapCloud/LCObject.h>
#import <LeapCloud/LCSubclassing.h>
#import <LeapCloud/LCObject+Subclass.h>
#import <LeapCloud/LCQuery.h>
#import <LeapCloud/LCSearchQuery.h>
#import <LeapCloud/LCInstallation.h>
#import <LeapCloud/LCRole.h>
#import <LeapCloud/LCUser.h>
#import <LeapCloud/LCAnonymousUtils.h>
#import <LeapCloud/LCPassport.h>
#import <LeapCloud/LCCloudCode.h>
#import <LeapCloud/LCFile.h>
#import <LeapCloud/LCPrivateFile.h>
#import <LeapCloud/LCCloudParam.h>
#import <LeapCloud/LCConfig.h>
#import <LeapCloud/LCEmail.h>
#import <LeapCloud/LCReceiptManager.h>
#import <LeapCloud/LCMarketingManager.h>
#import <LeapCloud/LCLogger.h>
#import <LeapCloud/LCAnalytics.h>
#import <LeapCloud/LCACurrency.h>
#import <LeapCloud/LCGAItem.h>
#import <LeapCloud/LCGAMission.h>
#import <LeapCloud/LCGAVirtureCurrency.h>

/*!
 The `LeapCloud` class contains static functions that handle global configuration for the LeapCloud framework.
 */
@interface LeapCloud : NSObject

/**
 *  Sets the applicationId and clientKey of your application.
 *
 *  @param applicationId The application id for your LeapCloud application.
 *  @param clientKey     The client key for your LeapCloud application.
 */
+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;

/*!
 The current application id that was used to configure LeapCloud framework.
 */
+ (NSString *)applicationId;

/*!
 The current client key that was used to configure LeapCloud framework.
 */
+ (NSString *)clientKey;

/**
 *  get the timeout interval for LeapCloud request
 *
 *  @return timeout interval
 */
+ (NSTimeInterval)networkTimeoutInterval;

/**
 *  set the timeout interval for LeapCloud request
 *
 *  @param timeoutInterval timeout interval
 */
+ (void)setNetworkTimeoutInterval:(NSTimeInterval)timeoutInterval;

@end

