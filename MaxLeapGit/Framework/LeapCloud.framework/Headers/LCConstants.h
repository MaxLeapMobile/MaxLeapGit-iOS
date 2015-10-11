// LCConstants.h
// Copyright (c) 2014 iLegendsoft. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LCObject, LCUser, LCPassport, LCFile, LCPrivateFile, LCConfig;

///--------------------------------------
/// @name Version
///--------------------------------------

// LeapCloud SDK Version
#define LeapCloud_VERSION @"1.6.0"

///--------------------------------------
/// @name Errors
///--------------------------------------

extern NSString *const LCErrorDomain;

/*!
 `LCErrorCode` enum contains all custom error codes that are used as `code` for `NSError` for callbacks on all classes.
 
 These codes are used when `domain` of `NSError` that you receive is set to `LCErrorDomain`.
 */
typedef NS_ENUM(NSInteger, LCErrorCode) {
    
    /*! @abstract 1: Internal server error. No information available. */
    kLCErrorInternalServer = 1,
    
    /*! @abstract 100: The connection to the LeapCloud servers failed. */
    kLCErrorConnectionFailed = 100,
    
    /*! @abstract 101: Object doesn't exist, or has an incorrect password. */
    kLCErrorObjectNotFound = 101,
    
    /*! @abstract 102: You tried to find values matching a datatype that doesn't support exact database matching, like an array or a dictionary. */
    kLCErrorInvalidQuery = 102,
    
    /*! @abstract 103: Missing or invalid classname. Classnames are case-sensitive. They must start with a letter, and a-zA-Z0-9_ are the only valid characters. */
    kLCErrorInvalidClassName = 103,
    
    /*! @abstract 104: Missing ObjectId, usually the objectId no introduction in the query time, or objectId is illegal. ObjectId string can only letters, numbers. */
    kLCErrorMissingObjectId = 104,
    
    /*! @abstract 105: Key is reserved. objectId, createdAt, updatedAt.<br> Invalid key name. Keys are case-sensitive. They must start with a letter, and a-zA-Z0-9_ are the only valid characters. */
    kLCErrorInvalidKeyName = 105,
    
    /*! @abstract 106: Invalid format. Date, Pointer, Relation…. */
    kLCErrorInvalidType = 106,
    
    /*! @abstract 107: Malformed json object. A json dictionary is expected. */
    kLCErrorInvalidJSON = 107,
    
    /*! @abstract 108: Tried to access a feature only available internally. */
    kLCErrorCommandUnavailable = 108,
    
    /** @abstract 109: +[LeapCloud setApplicationId:clientKey:] must be called before using the library. */
    kLCErrorCommandNotInitialized = 109,
    
    /** @abstract 110: Update syntax error. */
    kLCErrorInvalidUpdate = 110,
    
    /*! @abstract 111: Field set to incorrect type. */
    kLCErrorIncorrectType = 111,
    
    /*! @abstract 112: Invalid channel name. A channel name is either an empty string (the broadcast channel) or contains only a-zA-Z0-9_ characters and starts with a letter. */
    kLCErrorInvalidChannelName = 112,
    
    /** @abstract 113: BindTo class not found. */
    kLCErrorBindToClassNotFound = 113,
    
    /*! @abstract 115: Push is misconfigured. See details to find out how. */
    kLCErrorPushMisconfigured = 115,
    
    /*! @abstract 116: The object is too large. */
    kLCErrorObjectTooLarge = 116,
    
    /** @abstract 117: The parameters is invalid. */
    kLCErrorInvalidParameter = 117,
    
    /** @abstract 118: ObjectId is invalid. */
    kLCErrorInvalidObjectId = 118,
    
    /*! @abstract 119: That operation isn't allowed for clients. */
    kLCErrorOperationForbidden = 119,
    
    /*! @abstract 120: The results were not found in the cache. */
    kLCErrorCacheMiss = 120,
    
    /*! @abstract 121: An invalid key was used in a nested JSONObject. Keys in NSDictionary values may not include '$' or '.'. */
    kLCErrorInvalidNestedKey = 121,
    
    /*! @abstract 122: Invalid file name. A file name contains only a-zA-Z0-9_. characters and is between 1 and 36 characters. */
    kLCErrorInvalidFileName = 122,
    
    /*! @abstract 123: Invalid ACL. An ACL with an invalid format was saved. This should not happen if you use LCACL. */
    kLCErrorInvalidACL = 123,
    
    /*! @abstract 124: The request timed out on the server. Typically this indicates the request is too expensive. */
    kLCErrorTimeout = 124,
    
    /*! @abstract 125: The email address was invalid. */
    kLCErrorInvalidEmailAddress = 125,
    
    /** @abstract 136: Role name cannot be changed. */
    kLCErrorRoleNotChangeName = 136,
    
    /*! @abstract 137: A unique field was given a value that is already taken. */
    kLCErrorDuplicateValue = 137,
    
    /*! @abstract 139: Role's name is invalid. */
    kLCErrorInvalidRoleName = 139,
    
    /*! @abstract 140: Exceeded an application quota. Upgrade to resolve. */
    kLCErrorExceededQuota = 140,
    
    /*! @abstract 141: Cloud Code script had an error. */
    kLCScriptError = 141,
    
    /** @abstract 142: Role is not found. */
    kLCErrorRoleNotFound = 142,
    
    /** @abstract 143: The cloud code is not deployed. */
    kLCErrorCloudCodeNotDeployed = 143,
    
    /** @abstract 160: Session token is invalid. */
    kLCErrorInvalidToken = 160,
    
    /*! @abstract 200: Username is missing or empty */
    kLCErrorUsernameMissing = 200,
    
    /*! @abstract 201: Password is missing or empty */
    kLCErrorUserPasswordMissing = 201,
    
    /*! @abstract 202: Username has already been taken */
    kLCErrorUsernameTaken = 202,
    
    /*! @abstract 203: Email has already been taken */
    kLCErrorUserEmailTaken = 203,
    
    /*! @abstract 204: The email is missing, and must be specified */
    kLCErrorUserEmailMissing = 204,
    
    /*! @abstract 205: A user with the specified email was not found */
    kLCErrorUserWithEmailNotFound = 205,
    
    /*! @abstract 206: The user cannot be altered by a client without the session. */
    kLCErrorUserCannotBeAlteredWithoutSession = 206,
    
    /*! @abstract 207: Users can only be created through sign up */
    kLCErrorUserCanOnlyBeCreatedThroughSignUp = 207,
    
    /*! @abstract 208: An existing account already linked to another user. */
    kLCErrorAccountAlreadyLinked = 208,
    
    /** @abstract 210: Password does not match. */
    kLCErrorPasswordMisMatch = 210,
    
    /** @abstract 211: User not found. */
    kLCErrorUserNotFound = 211,
    
    /*! @abstract 250: User cannot be linked to an account because that account’s ID is not found. */
    kLCErrorLinkedIdMissing = 250,
    
    /*! @abstract 251: A user with a linked (e.g. Facebook) account has an invalid session. */
    kLCErrorInvalidLinkedSession = 251,
    
    /** @abstract 252: No supported account linking service found. */
    kLCErrorUnsupportedSevice = 252,
    
    /** @abstract 253: The authData must be Hash type, not null. */
    kLCErrorInvalidAuthData = 253,
    
    /** @abstract 301: CAPTCHA input is invalid. */
    kLCErrorInvalidCaptcha = 301,
    
    /** @abstract 401: Unauthorized access, no App ID, or App ID and App key verification failed. */
    kLCErrorUnauthorized = 401,
    
    /** @abstract 503: Rate limit exceeded. */
    kLCErrorRateLimit = 503,
    
    /** @abstract 600: The path has already been taken. */
    kLCErrorPathTaken = 600,
    
    /** @abstract 601: The path does not exists. */
    kLCErrorPathNotExist = 601,
    
    /** @abstract 602: Unexpected error. No infomation available. */
    kLCErrorUnexpected = 602,
    
    /** @abstract 90000: Unkown error */
    kLCErrorUnkown = 90000
};

///--------------------------------------
/// @name Blocks
///--------------------------------------

typedef void (^LCBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^LCIntegerResultBlock)(int number, NSError *error);
typedef void (^LCArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^LCDictionaryResultBlock)(NSDictionary *result, NSError *error);
typedef void (^LCObjectResultBlock)(LCObject *object, NSError *error);
typedef void (^LCUserResultBlock)(LCUser *user, NSError *error);
typedef void (^LCPassportResultBlock)(LCPassport *passport, NSError *error);
typedef void (^LCDataResultBlock)(NSData *data, NSError *error);
typedef void (^LCDataStreamResultBlock)(NSInputStream *stream, NSError *error);
typedef void (^LCStringResultBlock)(NSString *string, NSError *error);
typedef void (^LCIdResultBlock)(id object, NSError *error);
typedef void (^LCProgressBlock)(int percentDone);
typedef void (^LCFileResultBlock)(LCFile *file, NSError *error);
typedef void (^LCPrivateFileResultBlock)(LCPrivateFile *file, NSError *error);
typedef void (^LCConfigResultBlock)(LCConfig *config, NSError *error);
typedef void (^LCUsageResultBlock)(NSInteger fileCount, long usedCapacity, NSError *error);

#ifndef LC_DEPRECATED
#  ifdef __deprecated_msg
#    define LC_DEPRECATED(_MSG) __deprecated_msg(_MSG)
#  else
#    ifdef __deprecated
#      define LC_DEPRECATED(_MSG) __attribute__((deprecated))
#    else
#      define LC_DEPRECATED(_MSG)
#    endif
#  endif
#endif

#ifndef LC_EXTENSION_UNAVAILABLE
#  ifdef NS_EXTENSION_UNAVAILABLE_IOS
#    define LC_EXTENSION_UNAVAILABLE(_msg) NS_EXTENSION_UNAVAILABLE_IOS(_msg)
#  else
#    define LC_EXTENSION_UNAVAILABLE(_msg)
#  endif
#endif
