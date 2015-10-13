//
//  LCPassport.h
//  LeapCloud
//
//  Created by Sun Jin on 7/28/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCObject.h>
    #import <LeapCloudExt/LCSubclassing.h>
#else
    #import <LeapCloud/LCObject.h>
    #import <LeapCloud/LCSubclassing.h>
#endif

@class LCUser;

/*!
 A LeapCloud Framework Passport Object that is a local representation of a passport persisted to the LeapCloud. This class is a subclass of a LCObject, and retains the same functionality of a LCObject, but also extends it with various passport specific methods, like authentication, signing up, and validation uniqueness.<br>
 */
@interface LCPassport : LCObject <LCSubclassing>

/*! The name of the LCPassport class in the REST API. This is a required LCSubclassing method */
+ (NSString *)leapClassName;

/// The session token for the `LCPassport`. This is set by the server upon successful authentication.
@property (readonly, nonatomic, strong) NSString *sessionToken;

/** @name Accessing the Current LCPassport */

/*!
 Gets the currently logged in passport from disk and returns an instance of it.
 @return Returns a LCPassport that is the currently logged in passport. If there is none, returns nil.
 */
+ (LCPassport *)currentPassport;

/*!
 Whether the passport is an authenticated object for the device. An authenticated LCPassport is one that is obtained via a signUp or logIn method. An authenticated object is required in order to save (with altered values) or delete it.
 
 @return Returns whether the passport is authenticated.
 */
- (BOOL)isAuthenticated;

/** @name Creating a New Passport */

/*!
 Creates a new LCPassport object.
 @return Returns a new LCPassport object.
 */
+ (LCPassport *)passport;

/// The username for the LCPassport.
@property (nonatomic, strong) NSString *username;

/**
 The password for the LCPassport. This will not be filled in from the server with the password. It is only meant to be set.
 */
@property (nonatomic, strong) NSString *password;

/// The email for the LCPassport.
@property (nonatomic, strong) NSString *email;

@property (nonatomic, readonly) BOOL isNew;

/**
 The linked user of the passport in this app.
 If this value is nil, you can retrieve it by calling +[LCPassportManager getLinkedUserOfPassport:block:].
 */
@property (nonatomic, readonly) LCUser *linkedUser;

/** @name Querying for passports */

/*!
 Creates a query for LCPassport objects.
 */
+ (LCQuery *)query;

/*!
 Signs up the passport asynchronously. Make sure that password, username and email are set. This will also enforce that the username and email isn't already taken.
 
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
- (void)signUpInBackgroundWithBlock:(LCBooleanResultBlock)block;

/*!
 Signs up the passport asynchronously. Make sure that password, username and email are set. The capthca also cannot be nil. This will also enforce that the username and email isn't already taken.
 
 @param captcha     The captcha
 @param block       The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
- (void)signUpInBackgroundWithCaptcha:(NSDictionary *)captcha block:(LCBooleanResultBlock)block;

/** @name Logging in */

/*!
 Makes an asynchronous request to log in a passport with specified credentials. Returns an instance of the successfully logged in LCPassport. This will also cache the passport locally so that calls to currentPassport will use the latest logged in passport.
 
 @param loginId The username or email of the passport.
 @param password The password of the passport.
 @param block The block to execute. The block should have the following argument signature: (LCPassport *passport, NSError *error)
 */
+ (void)loginWithLoginIdInBackground:(NSString *)loginId password:(NSString *)password block:(LCPassportResultBlock)block;

/*!
 Logs out the currently logged in passport from server. If success, the cache of the passport on disk will be removed.
 
 @param block The block to execute. The block should have the following signature: (BOOL succeeded, NSError *error)
 */
+ (void)logoutInBackgroundWithBlock:(LCBooleanResultBlock)block;

#pragma mark -
///--------------------------------------
/// @name Linking User
///--------------------------------------

/*!
 Links an authenticated user with a passport asynchronously. Make sure that the user is authenticated and the passport's passport and loginId (username or email) are set.
 
 @param user        An authenticated user.
 @param block       The block to execute. The block should have the following signature: (BOOL succeeded, NSError *error)
 */
- (void)linkUserInBackground:(LCUser *)user block:(LCBooleanResultBlock)block;

/*!
 Get linked user of the passport asynchronously. Make sure that the passport is authenticated.
 
 @param block       The block to execute. The block should have the following signature: (LCUser *user, NSError *error)
 */
- (void)getLinkedUserInBackgroundWithBlock:(LCUserResultBlock)block;

/*!
 Unlinks a user with passport asynchronously. Make sure that the user is authenticated.
 
 @param user The user to unlink.
 @param block The block to execute. The block should have the following signature: (BOOL succeeded, NSError *error)
 */
+ (void)unlinkUserInBackground:(LCUser *)user block:(LCBooleanResultBlock)block;

#pragma mark -
///--------------------------------------
/// @name Coins
///--------------------------------------

/*!
 Increase coins in current app.
 
 @param coins The number of coins to increase
 @param block The block to execute when request completed. The block should have the following signature: (BOOL succeeded, NSError *error)
 */
- (void)earnAppCoin:(NSUInteger)coins block:(LCBooleanResultBlock)block;

/*!
 Consume coins in current app.
 
 @param coins The number of coins to consume.
 @param block The block to execute when request completed. The block should have the following signature: (BOOL succeeded, NSError *error)
 */
- (void)consumeAppCoin:(NSUInteger)coins block:(LCBooleanResultBlock)block;

@end
