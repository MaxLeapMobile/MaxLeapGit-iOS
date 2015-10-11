//
//  LCUser.h
//  LeapCloud
//
//  Created by Sun Jin on 6/23/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCObject.h>
    #import <LeapCloudExt/LCConstants.h>
    #import <LeapCloudExt/LCSubclassing.h>
#else
    #import <LeapCloud/LCObject.h>
    #import <LeapCloud/LCConstants.h>
    #import <LeapCloud/LCSubclassing.h>
#endif

@class LCQuery;

/*!
 A LeapCloud Framework User Object that is a local representation of a user persisted to the LeapCloud. This class is a subclass of a LCObject, and retains the same functionality of a LCObject. You can also user LCDataManager's api to update a user.<br>
 */
@interface LCUser : LCObject <LCSubclassing>

/*! The name of the LCUser class in the REST API. This is a required
 *  LCSubclassing method 
 */
+ (NSString *)leapClassName;

/// The session token for the LCUser. This is set by the server upon successful authentication.
@property (nonatomic, strong) NSString *sessionToken;

/// Whether the LCUser was just created from a request. This is only set after a Facebook or Twitter login.
@property (readonly, nonatomic) BOOL isNew;

/** @name Accessing the Current User */

/*!
 Gets the currently logged in user from disk and returns an instance of it.
 @return Returns a LCUser that is the currently logged in user. If there is none, returns nil.
 */
+ (instancetype)currentUser;

/*!
 Enables automatic creation of anonymous users.  After calling this method, [LCUser currentUser] will always have a value. The user will only be created on the server once the user has been saved, or once an object with a relation to that user or an ACL that refers to the user has been saved.<br>
 
 Note: saveEventually will not work if an item being saved has a relation to an automatic user that has never been saved.
 */
+ (void)enableAutomaticUser;

/** @name Creating a New User */

/*!
 Creates a new LCUser object.
 @return Returns a new LCUser object.
 */
+ (instancetype)user;

/*!
 Whether the user is an authenticated object for the device. An authenticated LCUser is one that is obtained via a signUp or logIn method. An authenticated object is required in order to save (with altered values) or delete it.
 
 @return Returns whether the user is authenticated.
 */
- (BOOL)isAuthenticated;

/**
 *  The username for the LCUser.
 */
@property (nonatomic, strong) NSString *username;

/**
 The password for the LCUser. This will not be filled in from the server with the password. It is only meant to be set.
 */
@property (nonatomic, strong) NSString *password;

/**
 *  The email for the LCUser.
 */
@property (nonatomic, strong) NSString *email;

/**
 *  Whether the email is veriified.
 */
@property (nonatomic, readonly) BOOL emailVerified;

/**
 *  The linked passport's objectId
 */
@property (nonatomic, strong, readonly) NSString *passportId;

/** @name Querying for Users */

/**
 *  Creates a query for LCUser objects.
 *
 *  @return a query for LCUser objects.
 */
+ (LCQuery *)query;

/*!
 Signs up the user asynchronously. Make sure that password and username are set. This will also enforce that the username isn't already taken.
 
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
- (void)signUpInBackgroundWithBlock:(LCBooleanResultBlock)block;

/** @name Logging in */

/*!
 Makes an asynchronous request to log in a user with specified credentials. Returns an instance of the successfully logged in LCUser. This will also cache the user locally so that calls to currentUser will use the latest logged in user.
 
 @param username The username of the user.
 @param password The password of the user.
 @param block The block to execute. The block should have the following argument signature: (LCUser *user, NSError *error)
 */
+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password
                                block:(LCUserResultBlock)block;

/** @name Becoming a user */
/*!
 Makes an asynchronous request to become a user with the given session token. Returns an instance of the successfully logged in LCUser. This also caches the user locally so that calls to currentUser will use the latest logged in user. The selector for the callback should look like: myCallback:(LCUser *)user error:(NSError **)error
 
 @param sessionToken The session token for the user.
 @param block The block to execute. The block should have the following argument signature: (LCUser *user, NSError *error)
 */
+ (void)becomeInBackgroundWithSessionToken:(NSString *)sessionToken block:(LCUserResultBlock)block;

/** @name Logging Out */

/*!
 Logs out the currently logged in user on disk.
 */
+ (void)logOut;

/** @name Requesting a Password Reset */

/*!
 Send a password reset request asynchronously for a specified email. If a user account exists with that email, an email will be sent to that address with instructions on how to reset their password.
 
 @param email Email of the account to send a reset password request.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
+ (void)requestPasswordResetForEmailInBackground:(NSString *)email block:(LCBooleanResultBlock)block;

/** @name Requesting a Email Verify */

/*!
 Send a email verify request asynchronously for a specified email. If a user account exists with that email, an email will be sent to that address with instructions on how to verify their email.
 
 @param email Email of the account to verify.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
+ (void)requestEmailVerifyForEmailInBackground:(NSString *)email block:(LCBooleanResultBlock)block;

/**
 *  Check whether the password matches the user.
 *
 *  @param password a password
 *  @param block    The block to execute. The block should have the following argument signature: (BOOL isMatch, NSError *error)
 */
- (void)checkIsPasswordMatchInBackground:(NSString *)password block:(LCBooleanResultBlock)block;

/**
 *  Check whether the password machtes the LCUser which's username is "username".
 *
 *  @param password the password
 *  @param username the username
 *  @param block    The block to execute. The block should have the following argument signature: (BOOL isMatch, NSError *error)
 */
+ (void)checkIsPassword:(NSString *)password matchUsernameInBackground:(NSString *)username block:(LCBooleanResultBlock)block;

/**
 *  Check the username is exist or not.
 *
 *  @discussion Empty username is not exist becuause it's not valid.
 *
 *  @param username The username to check
 *  @param block    The block to execute. The block should have the following argument signature: (BOOL isExist, NSError *error)
 */
+ (void)checkUsernameExists:(NSString *)username block:(LCBooleanResultBlock)block;

@end
