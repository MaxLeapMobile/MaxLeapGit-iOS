//
//  LCConfig.h
//  LeapCloud
//
//  Created by Sun Jin on 15/2/9.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCConstants.h>
#else
    #import <LeapCloud/LCConstants.h>
#endif

@class LCGeoPoint, LCFile;

/**
 *  @abstract
 *  The type of blocks submitted to config manager to get config valued changed event, which take two arguments and not return value.
 *
 *  @param newValue new value after config value change
 *  @param oldValue old value before config value change
 */
typedef void (^LCConfigValueChangedBlock)(id newValue, id oldValue);

/*!
 `LCConfig` is a representation of the remote configuration object.
 It enables you to add things like feature gating, a/b testing or simple "Message of the day".
 */
@interface LCConfig : NSObject

///--------------------------------------
/// @name Parameters
///--------------------------------------

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 
 @returns The value associated with `key`, or `nil` if there is no such value.
 */
- (id)objectForKey:(NSString *)key;

/*!
 @abstract Returns the object associated with a given key.
 
 @discussion This method enables usage of literal syntax on `LCConfig`.
 E.g. `NSString *value = config[@"key"];`
 
 @see objectForKey:
 
 @param keyedSubscript The keyed subscript for which to return the corresponding configuration value.
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (id)objectForKeyedSubscript:(NSString *)keyedSubscript;

/*!
 @abstract Returns the object as string value associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (NSDate *)dateForKey:(NSString *)key defaultValue:(NSDate *)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (NSArray *)arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (NSDictionary *)dictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (LCFile *)fileForKey:(NSString *)key defaultValue:(LCFile *)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (LCGeoPoint *)geoPointForKey:(NSString *)key defaultValue:(LCGeoPoint *)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (NSNumber *)numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue;

/*!
 @abstract Returns the object associated with a given key.
 
 @param key The key for which to return the corresponding configuration value.
 @param defaultValue The default value will be returned if there is no such value
 
 @returns The value associated with `key`, or `defaultValue` if there is no such value.
 */
- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue;

///--------------------------------------
/// @name Current Config
///--------------------------------------

/*!
 @abstract Returns the most recently fetched config.
 
 @discussion If there was no config fetched - this method will return an empty instance of `LCConfig`.
 
 @returns Current, last fetched instance of LCConfig.
 */
+ (LCConfig *)currentConfig;

///--------------------------------------
/// @name Retrieving Config
///--------------------------------------

/*!
 @abstract Gets the `LCConfig` *asynchronously* and executes the given callback block.
 
 @param block The block to execute. It should have the following argument signature: `^(LCConfig *config, NSError *error)`.
 */
+ (void)getConfigInBackgroundWithBlock:(LCConfigResultBlock)block;

/**
 *  Gets the `LCConfig` *asynchronously* for the given keys from LeapCloud servers and executes the given callback block.
 *
 *  @param keys  The keys to get, pass `nil` to get all key-values.
 *  @param block The block to execute. It should have the following argument signature: `^(LCConfig *config, NSError *error)`.
 */
+ (void)getValuesForKeys:(NSArray *)keys inBackgroundWithBlock:(LCConfigResultBlock)block;

///--------------------------------------
/// @name Observe Config Changes
///--------------------------------------

/**
 *  Registers anObserver to receive config value changed notifications for the specified key relative to the current config.
 *  The observer is not retained.
 *
 *  @param observer The object to register for config value changed notifications.
 *  @param key      The key, relative to the current config, of the property to observe. This value must not be nil.
 *  @param block    The callback to be excuted when value for the specified key changed. It should have the following argument signature: `^(id newValue, id oldValue)`.
 */
+ (void)addObserver:(NSObject *)observer forKey:(NSString *)key valueChangedHandler:(LCConfigValueChangedBlock)block;

/**
 *  Stops a given object from receiving config value change notifications for the property specified by a given key relative to the current config.
 *  Be sure to invoke this method (or removeObserver:) before any object specified in addObserver:forKey:valueChangedHandler: is deallocated.
 *
 *  @param observer The object to remove as an observer.
 *  @param key      A key, relative to the current config, for which anObserver is registered to receive config value change notifications.
 */
+ (void)removeObserver:(NSObject *)observer forKey:(NSString *)key;

/**
 *  Stops a given object from receiving config value change notifications.
 *  Be sure to invoke this method (or removeObserver:forKey:) before any object specified in addObserver:forKey:valueChangedHandler: is deallocated.
 *
 *  @param observer The object to remove as an observer.
 */
+ (void)removeObserver:(NSObject *)observer;

@end
