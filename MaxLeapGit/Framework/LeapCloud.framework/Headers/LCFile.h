//
//  LCFile.h
//  LeapCloud
//
//  Created by Sun Jin on 11/10/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCConstants.h>
#else
    #import <LeapCloud/LCConstants.h>
#endif

/*!
 A file of binary data stored on the LeapCloud servers. This can be a image, video, or anything else
 that an application needs to reference in a non-relational way.
 */
@interface LCFile : NSObject

/** @name Creating a LCFile */

/*!
 Creates a file with given data. A name will be assigned to it by the server.
 @param data The contents of the new LCFile.
 @result A LCFile.
 */
+ (instancetype)fileWithData:(NSData *)data;

/*!
 Creates a file with given data and name.
 @param name The name of the new LCFile.
 @param data The contents of hte new LCFile.
 @result A LCFile.
 */
+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data;

/*!
 Creates a file with the contents of another file.
 @param name The name of the new LCFile
 @param path The path to the file that will be uploaded to LeapCloud
 */
+ (instancetype)fileWithName:(NSString *)name contentsAtPath:(NSString *)path;

/*!
 The name of the file.
 */
@property (readonly) NSString *name;

/*!
 The url of the file.
 */
@property (readonly) NSString *url;

@property (readonly) long long size;

/*!
 Whether the file has been uploaded for the first time.
 */
@property (readonly) BOOL isDirty;

/*!
 Whether the data is available in memory or needs to be downloaded.
 */
@property (assign, readonly) BOOL isDataAvailable;

#pragma mark -
///--------------------------------------
/// @name Storing Data with LeapCloud
///--------------------------------------

/*!
 Saves the file asynchronously and executes the given block.
 
 @param block   The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
- (void)saveInBackgroundWithBlock:(LCBooleanResultBlock)block;

/*!
 Saves the file asynchronously and executes the given resultBlock. Executes the progressBlock periodically with the percent
 progress. progressBlock will get called with 100 before resultBlock is called.
 
 @param file    The file to save.
 @param block   The block should have the following argument signature: (BOOL succeeded, NSError *error)
 @param progressBlock The block should have the following argument signature: (int percentDone)
 */
- (void)saveInBackgroundWithBlock:(LCBooleanResultBlock)block progressBlock:(LCProgressBlock)progressBlock;

#pragma mark -
///--------------------------------------
/// @name Getting Data from LeapCloud
///--------------------------------------

/*!
 Synchronously gets the data from cache if available or fetches its contents from the LeapCloud servers. Sets an error if it occurs.
 
 @param error   Pointer to an NSError that will be set if necessary.
 @result The data of file. Returns nil if there was an error in fetching.
 */
- (NSData *)getData:(NSError **)error;

/*!
 Asynchronously gets the data from cache if available or fetches its contents
 from the LeapCloud servers. Executes the given block.
 
 @param block   The block should have the following argument signature: (NSData *result, NSError *error)
 */
- (void)getDataInBackgroundWithBlock:(LCDataResultBlock)block;

/*!
 This method is like getDataInBackgroundWithBlock: but avoids ever holding the
 entire LCFile's contents in memory at once. This can help applications with
 many large LCFiles avoid memory warnings.
 
 @param block   The block should have the following argument signature: (NSInputStream *result, NSError *error)
 */
- (void)getDataStreamInBackgroundWithBlock:(LCDataStreamResultBlock)block;

/*!
 Asynchronously gets the data from cache if available or fetches its contents
 from the LeapCloud servers. Executes the resultBlock upon
 completion or error. Executes the progressBlock periodically with the percent progress. progressBlock will get called with 100 before resultBlock is called.
 
 @param resultBlock     The block should have the following argument signature: (NSData *result, NSError *error)
 @param progressBlock   The block should have the following argument signature: (int percentDone)
 */
- (void)getDataInBackgroundWithBlock:(LCDataResultBlock)resultBlock progressBlock:(LCProgressBlock)progressBlock;

/*!
 This method is like getDataInBackgroundWithBlock:progressBlock: but avoids ever
 holding the entire LCFile's contents in memory at once. This can help
 applications with many large LCFiles avoid memory warnings.
 
 @param resultBlock     The block should have the following argument signature: (NSInputStream *result, NSError *error)
 @param progressBlock   The block should have the following argument signature: (int percentDone)
 */
- (void)getDataStreamInBackgroundWithBlock:(LCDataStreamResultBlock)resultBlock progressBlock:(LCProgressBlock)progressBlock;

#pragma mark -
///--------------------------------------
/// @name Interrupting a Transfer
///--------------------------------------

/*!
 Cancels the current request (whether upload or download of file data).
 */
- (void)cancel;

#pragma mark -
///--------------------------------------
/// @name Other Methods
///--------------------------------------

/*!
 Get file with specified name.
 
 @param name    The name of a file.
 @param block   The block will execute on main thread.
 */
+ (void)getFileInBackgroundWithName:(NSString *)name block:(LCFileResultBlock)block;

/*!
 Get all files uploaded by current user.
 
 @param block The callback, will be executed on main thread. The block should have the following argument signature: (NSArray *objects, NSError *error).
 */
+ (void)getAllInBackgroundWithBlock:(LCArrayResultBlock)block;

@end
