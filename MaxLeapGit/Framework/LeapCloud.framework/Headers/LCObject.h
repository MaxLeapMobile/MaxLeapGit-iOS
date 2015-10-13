//
//  LCObject.h
//  LeapCloud
//
//  Created by Sun Jin on 6/23/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCConstants.h>
#else
    #import <LeapCloud/LCConstants.h>
#endif

@class LCACL, LCRelation;

/*!
 A LeapCloud Framework Object that is a local representation of data persisted to the LeapCloud. This is the main class that is used to interact with objects in your app.
 */
@interface LCObject : NSObject

#pragma - mark Constructors

/*! @name Creating a LCObject */

/*!
 Creates a new LCObject with a class name.
 
 @param className A class name can be any alphanumeric string that begins with a letter. It represents an object in your app, like a User of a Document.
 
 @return Returns the object that is instantiated with the given class name.
 */
+ (instancetype)objectWithClassName:(NSString *)className;

/*!
 Creates a reference to an existing LCObject for use in creating associations between LCObjects.  Calling isDataAvailable on this object will return NO until fetchIfNeeded or refresh has been called.  No network request will be made.
 
 @param className The object's class.
 @param objectId The object id for the referenced object.
 @return A LCObject without data.
 */
+ (instancetype)objectWithoutDataWithClassName:(NSString *)className objectId:(NSString *)objectId;

/*!
 Creates a new LCObject with a class name, initialized with data constructed from the specified set of objects and keys.
 
 @param className The object's class.
 @param dictionary An NSDictionary of keys and objects to set on the new LCObject.
 @return A LCObject with the given class name and set with the given data.
 */
+ (instancetype)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary;

/*!
 Initializes a new LCObject with a class name.
 
 @param newClassName A class name can be any alphanumeric string that begins with a letter. It represents an object in your app, like a User or a Document.
 @return Returns the object that is instantiated with the given class name.
 */
- (id)initWithClassName:(NSString *)newClassName;

#pragma mark -
#pragma mark Properties

/*! @name Managing Object Properties */

/*!
 The class name of the object.
 */
@property (nonatomic, readonly) NSString *leapClassName;

/*!
 The id of the object.
 */
@property (nonatomic, strong, readonly) NSString *objectId;

/*!
 When the object was last updated.
 */
@property (nonatomic, strong, readonly) NSDate *updatedAt;

/*!
 When the object was created.
 */
@property (nonatomic, strong, readonly) NSDate *createdAt;

/*!
 The ACL for this object.
 */
@property (nonatomic, strong, readonly) LCACL *ACL;

/*!
 Returns an array of the keys contained in this object. This does not include createdAt, updatedAt, authData, or objectId. It does include things like username and ACL.
 */
- (NSArray *)allKeys;



#pragma mark -
#pragma mark Get and set

/*!
 Returns the object associated with a given key.
 
 @param key The key that the object is associated with.
 @return The value associated with the given key, or nil if no value is associated with key.
 */
- (id)objectForKey:(NSString *)key;

/*!
 Sets the object associated with a given key.
 
 Set nil to unset a key on the object.
 
 @param object The object.
 @param key The key.
 */
- (void)setObject:(id)object forKey:(NSString *)key;

/*!
 Unsets a key on the object.
 
 @param key The key.
 */
- (void)removeObjectForKey:(NSString *)key;

/*!
 * In LLVM 4.0 (XCode 4.5) or higher allows myLCObject[key].
 
 @param key The key.
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/*!
 * In LLVM 4.0 (XCode 4.5) or higher allows myObject[key] = value
 
 @param object The object.
 @param key The key.
 */
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

/*!
 Returns the relation object associated with the given key
 
 @param key The key that the relation is associated with.
 */
- (LCRelation *)relationForKey:(NSString *)key;

#pragma mark -
#pragma mark Array add and remove

/*!
 Adds an object to the end of the array associated with a given key.
 
 @param object The object to add.
 @param key The key.
 */
- (void)addObject:(id)object forKey:(NSString *)key;

/*!
 Adds the objects contained in another array to the end of the array associated with a given key.
 
 @param objects The array of objects to add.
 @param key The key.
 */
- (void)addObjectsFromArray:(NSArray *)objects forKey:(NSString *)key;

/*!
 Adds an object to the array associated with a given key, only if it is not already present in the array. The position of the insert is not guaranteed.
 
 @param object The object to add.
 @param key The key.
 */
- (void)addUniqueObject:(id)object forKey:(NSString *)key;

/*!
 Adds the objects contained in another array to the array associated with a given key, only adding elements which are not already present in the array. The position of the insert is not guaranteed.
 
 @param objects The array of objects to add.
 @param key The key.
 */
- (void)addUniqueObjectsFromArray:(NSArray *)objects forKey:(NSString *)key;

/*!
 Removes all occurrences of an object from the array associated with a given key.
 
 @param object The object to remove.
 @param key The key.
 */
- (void)removeObject:(id)object forKey:(NSString *)key;

/*!
 Removes all occurrences of the objects contained in another array from the array associated with a given key.
 
 @param objects The array of objects to remove.
 @param key The key.
 */
- (void)removeObjectsInArray:(NSArray *)objects forKey:(NSString *)key;

#pragma mark -
#pragma mark Increment

/*!
 Increments the given key by 1.
 
 @param key The key.
 */
- (void)incrementKey:(NSString *)key;

/*!
 Increments the given key by a number.
 
 @param key The key.
 @param amount The amount to increment.
 */
- (void)incrementKey:(NSString *)key byAmount:(NSNumber *)amount;

#pragma mark -
#pragma mark Clear

/**
 *  Clear all keys on this object by creating delete operations for each key.
 */
- (void)clear;

#pragma mark -
#pragma mark Data Availability

/*!
 Gets whether the LCObject has been fetched.
 @return YES if the LCObject is new or has been fetched or refreshed.  NO otherwise.
 */
- (BOOL)isDataAvailable;

#pragma mark -
#pragma Dirtiness

/*!
 Gets whether any key-value pair in this object (or its children) has been added/updated/removed and not saved yet.
 @return Returns whether this object has been altered and not saved yet.
 */
- (BOOL)isDirty;

/*!
 Get whether a value associated with a key has been added/updated/removed and not saved yet.
 @param key The key to check for
 @return Returns whether this key has been altered and not saved yet.
 */
- (BOOL)isDirtyForKey:(NSString *)key;

#pragma mark -
#pragma mark Save

/*! @name Saving an Object to LeapCloud */

/*!
 Save asynchronously and executes the given callback block.
 
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
- (void)saveInBackgroundWithBlock:(LCBooleanResultBlock)block;

/*! @name Saving Many Objects to LeapCloud */

/*!
 Saves a collection of objects all at once asynchronously and the block when done.
 
 @param objects The array of objects to save.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
+ (void)saveAllInBackground:(NSArray *)objects block:(LCBooleanResultBlock)block;

#pragma mark -
#pragma mark Delete

/*! @name Removing an Object from LeapCloud */

/*!
 Deletes the LCObject asynchronously and executes the given callback block.
 
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
- (void)deleteInBackgroundWithBlock:(LCBooleanResultBlock)block;

/*! @name Delete Many Objects from LeapCloud */

/*!
 Deletes a collection of objects all at once asynchronously and excutes the block when done.
 
 @param objects The array of objects to delete.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
+ (void)deleteAllInBackground:(NSArray *)objects block:(LCBooleanResultBlock)block;

#pragma mark -
#pragma mark Fetch

/*! @name Getting an Object from LeapCloud */

/**
 *  Fetches the LCObject asynchronously and executes the given callback block.
 *
 *  @param block  The block to execute. The block should have the following argument signature: (LCObject *object, NSError *error)
 */
- (void)fetchInBackgroundWithBlock:(LCObjectResultBlock)block;

/**
 *  Fetches the LCObject's data asynchronously if isDataAvailable is false, then calls the callback block.
 *
 *  @param block  block The block to execute.  The block should have the following argument signature: (LCObject *object, NSError *error)
 */
- (void)fetchIfNeededInBackgroundWithBlock:(LCObjectResultBlock)block;


/*! @name Getting Many Objects from LeapCloud */

/**
 *  Fetches all of the LCObjects with the current data from the server asynchronously and calls the given block.
 *
 *  @param objects An NSArray of LCObjects.
 *  @param block   The block to execute. The block should have the following argument signature: (NSArray *objects, NSError *error)
 */
+ (void)fetchAllInBackground:(NSArray *)objects block:(LCArrayResultBlock)block;

/**
 *  Fetches all of the LCObjects with the current data from the server asynchronously and calls the given block.
 *
 *  @param objects The list of objects to fetch.
 *  @param block   The block to execute. The block should have the following argument signature: (NSArray *objects, NSError *error)
 */
+ (void)fetchAllIfNeededInBackground:(NSArray *)objects block:(LCArrayResultBlock)block;


@end
