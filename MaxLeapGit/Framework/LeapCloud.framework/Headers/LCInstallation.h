//
//  LCInstallation.h
//  LeapCloud
//
//  Created by Sun Jin on 7/8/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCObject.h>
    #import <LeapCloudExt/LCSubclassing.h>
#else
    #import <LeapCloud/LCObject.h>
    #import <LeapCloud/LCSubclassing.h>
#endif

@class LCQuery;

/*!
 A LeapCloud Framework Installation Object that is a local representation of an installation persisted to the LeapCloud. This class is a subclass of a LCObject, and retains the same functionality of a LCObject, but also extends it with installation-specific fields and related immutability and validity checks.<br>
 
 A valid LCInstallation can only be instantiated via +[LCInstallation currentInstallation] because the required identifier fields are readonly. The timeZone and badge fields are also readonly properties which are automatically updated to match the device's time zone and application badge when the LCInstallation is saved, thus these fields might not reflect the latest device state if the installation has not recently been saved.<br>
 
 LCInstallation objects which have a valid deviceToken and are saved to the LeapCloud can be used to target push notifications.<br>
 
 This class is currently for iOS only. There is no LCInstallation for LeapCloud applications running on OS X, because they cannot receive push notifications.
 */
@interface LCInstallation : LCObject <LCSubclassing>

/** The name of the Installation class in the REST API. This is a required
 *  LCSubclassing method
 */
+ (NSString *)leapClassName;

/** @name Targeting Installations */

/*!
 Creates a query for LCInstallation objects. The resulting query can only be used for targeting a LCPush. Calling find methods on the resulting query will raise an exception.
 
 @return Return a query for LCInstallation objects.
 */
+ (LCQuery *)query;

/** @name Accessing the Current Installation */

/*!
 Gets the currently-running installation from disk and returns an instance of it. If this installation is not stored on disk, returns a LCInstallation with deviceType and installationId fields set to those of the current installation.
 
 @return Returns a LCInstallation that represents the currently-running installation.
 */
+ (instancetype)currentInstallation;

/** @name Properties */

/*!
 Sets the device token string property from an NSData-encoded token.
 @param deviceTokenData The deviceToken got from `application:didRegisterForRemoteNotificationsWithDeviceToken:` method.
 */
- (void)setDeviceTokenFromData:(NSData *)deviceTokenData;

/// The device type for the LCInstallation.
@property (nonatomic, readonly, strong) NSString *deviceType;

/// The installationId for the LCInstallation.
@property (nonatomic, readonly, strong) NSString *installationId;

/// The device token for the LCInstallation.
@property (nonatomic, strong) NSString *deviceToken;

/// The badge for the LCInstallation.
@property (nonatomic, assign) NSInteger badge;

/// The timeZone for the LCInstallation.
@property (nonatomic, readonly, strong) NSString *timeZone;

/// The channels for the LCInstallation.
@property (nonatomic, strong) NSArray *channels;

@end
