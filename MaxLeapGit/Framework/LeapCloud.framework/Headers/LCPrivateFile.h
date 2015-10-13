//
//  LCPrivateFile.h
//  LeapCloud
//
//  Created by Sun Jin on 15/4/8.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCConstants.h>
#else
    #import <LeapCloud/LCConstants.h>
#endif

/**
 *  A LeapCloud Framework object that represents metadata of private file.
 */
@interface LCPrivateFile : NSObject

#pragma mark -
///--------------------------------------
/// @name Creating a Private File
///--------------------------------------

/**
 *  Initialize a privateFile with localPath and remotePath.
 *
 *  @param localPath  The path of the file on local disk.
 *  @param remotePath The path of the file on remote server, shouldn't be nil.
 *
 *  @return A private file instance.
 */
- (instancetype)initWithLocalFileAtPath:(NSString *)localPath remotePath:(NSString *)remotePath NS_DESIGNATED_INITIALIZER;

/**
 *  Create a privateFile with remotePath.
 *
 *  @param remotePath The path of the file on remote server, shouldn't be nil.
 *
 *  @return A private file instance
 */
+ (instancetype)fileWithRemotePath:(NSString *)remotePath;

#pragma mark -
///--------------------------------------
/// @name Properties - File Metadata
///--------------------------------------

/**
 *  A formated string representing the item size, eg: "1.1 MB", "832.5 KB".
 */
@property (nonatomic, readonly) NSString *size;

/**
 *  A number indicates the size of item in bytes.
 */
@property (nonatomic, readonly) NSUInteger bytes;

/**
 *  The file's MIMEType.
 */
@property (nonatomic, readonly) NSString *MIMEType;

/**
 *  Hash of the source file.
 */
@property (nonatomic, copy) NSString *fileHash;

/**
 *  When the file or directory was created.
 */
@property (nonatomic, readonly) NSDate *createdAt;

/**
 *  When the file or directory was last updated.
 */
@property (nonatomic, readonly) NSDate *updatedAt;

/**
 *  The item's path on remote server.
 */
@property (nonatomic, readonly) NSString *remotePath;

/**
 *  The local path of the item.
 */
@property (nonatomic, copy) NSString *localPath;

/**
 *  Whether this item is a directory.
 */
@property (nonatomic, readonly) BOOL isDirectory;

/**
 *  The contents of the dir. If this item is not a directory, contents is nil.
 */
@property (nonatomic, readonly) NSArray *contents;

/**
 *  Whether the item is deleted from remote server.
 */
@property (nonatomic, readonly) BOOL isDeleted;

/**
 *  Whether the item is shared from another user.
 */
@property (nonatomic, readonly) BOOL isShared;

/**
 *  The id of user who shared this item.
 */
@property (nonatomic, readonly) NSString *shareFrom;

/**
 *  The share url.
 */
@property (nonatomic, readonly) NSURL *url;

#pragma mark -
/*! @name Upload Private Files */

/**
 *  *Asynchronously* upload file at file.localPath to LeapCloud file servers.
 *
 *  @disscussion If the file's fileHash is not set, the md5 of file will be calculated and used.
 *  If file exists on remote path, the uploading will fail with a kLCErrorPathTaken error.
 *
 *  @param block Block to excute on main thread after uploading file, it should have the following argument signature: (BOOL success, NSError *error)
 */
- (void)saveInBackgroundWithBlock:(LCBooleanResultBlock)block;

/**
 *  *Asynchronously* upload file at file.localPath and save at the file.remotePath on LeapCloud file servers.
 *
 *  @disscussion If the file's fileHash is not set, the md5 of file will be calculated and used.
 *  If file exists on remote path, it will be overwrite.
 *
 *  @param block Block to excute on main thread after uploading file, it should have the following argument signature: (BOOL success, NSError *error)
 */
- (void)saveAndOverwriteInBackgroundWithBlock:(LCBooleanResultBlock)block;

/**
 *  *Asynchronously* upload file at file.localPath and save at the file.remotePath on LeapCloud file servers.
 *
 *  @disscussion If the file's fileHash is not set, the md5 of file will be calculated and used.
 *  If file exists on remote path, the uploading will fail with a kLCErrorPathTaken error.
 *
 *  @param block            Block to excute on main thread after uploading file, it should have the following argument signature: (BOOL success, NSError *error)
 *  @param progressBlock    Block to notify the upload progress, it should have the following argument signature: (int percentDone)
 */
- (void)saveInBackgroundWithBlock:(LCBooleanResultBlock)block progressBlock:(LCProgressBlock)progressBlock;

/**
 *  *Asynchronously* upload file at file.localPath and save at the file.remotePath on LeapCloud file servers.
 *
 *  @disscussion If the file's fileHash is not set, the md5 of file will be calculated and used.
 *  If file exists on remote path, it will be overwrite.
 *
 *  @param block            Block to excute on main thread after uploading file, it should have the following argument signature: (BOOL success, NSError *error)
 *  @param progressBlock    Block to notify the upload progress, it should have the following argument signature: (int percentDone)
 */
- (void)saveAndOverwriteInBackgroundWithBlock:(LCBooleanResultBlock)block progressBlock:(LCProgressBlock)progressBlock;

#pragma mark -
/*! @name Download Private Files */

/**
 *  Download and save the data at file.localPath. If the local path is nil, default path will be used.
 *
 *  @param block Block to excute after file downloading. It should have the following argument signature: (NSString *filePath, NSError *error)
 */
- (void)downloadInBackgroundWithBlock:(LCBooleanResultBlock)block;

/**
 *  Download and save the data at file.localPath. If the local path is nil, default path will be used.
 *
 *  @param block         Block to excute after file downloading. It should have the following argument signature: (NSString *filePath, NSError *error)
 *  @param progressBlock Block to notify the upload progress, it should have the following argument signature: (int percentDone)
 */
- (void)downloadInBackgroundWithBlock:(LCBooleanResultBlock)block progressBlock:(LCProgressBlock)progressBlock;

/*!
 Cancels the current request (whether upload or download of file data).
 */
- (void)cancel;

#pragma mark -
/*! @name Delete Private Files */

/**
 *  Delete the file at file.remotePath from remote server.
 *
 *  @param block Block to excute after deleting, it should have the following argument signature: (BOOL success, NSError *error)
 */
- (void)deleteInBackgroundWithBlock:(LCBooleanResultBlock)block;

/**
 *  Delete the file at the path from remote server.
 *
 *  @param path  the remote path to delete
 *  @param block Block to excute after deleting, it should have the following argument signature: (BOOL success, NSError *error)
 */
+ (void)deletePathInBackground:(NSString *)path block:(LCBooleanResultBlock)block;

/**
 *  Deletes a collection of files all at once asynchronously and excutes the block when done.
 *
 *  @param fileList A collection of files to delete.
 *  @param block    The block should have the following argument signature: (BOOL success, NSError *error)
 */
+ (void)deleteAllInBackground:(NSArray *)filePaths block:(void (^)(BOOL isAllDeleted, NSArray *deleted, NSError *error))block;

#pragma mark -
/*! @name Get Metadata of a Private File */

/**
 *  Gets the metadata of a file and then excutes the block.
 *
 *  @param block             The block should have the following argument signature: (BOOL success, NSError *error)
 */
- (void)getMetadataInBackgroundWithBlock:(LCBooleanResultBlock)block;

/**
 *  Gets the metadata of a file including its children if it's a directory and then excutes the block.
 *
 *  @param block             The block should have the following argument signature: (BOOL success, NSError *error)
 */
- (void)getMetadataIncludeChildrenInBackgroundWithBlock:(LCBooleanResultBlock)block;

/**
 *  Gets the metadata of a file and excutes the block when done.
 *
 *  @param skip     The number of file metadata to skip before returning any.
 *  @param limit    A limit on the number of file metadata to return. The default limit is 200, with a maximum of 2000 results being returned at a time.
 *  @param block    The block should have the following argument signature: (BOOL success, NSError *error)
 */
- (void)getMetadataInBackgroundWithSkip:(int)skip andLimit:(int)limit block:(LCBooleanResultBlock)block;

#pragma mark -
/*! @name Get usage */

/**
 *  Get the usage of current user.
 *
 *  @param block The block parameter represents usage of current user. It has 3 parameters. 1. fileCount: How many private files the current user save on LeapCloud file servers. 2. usedCapacity: The capacity current user used in bytes. 3. error: If there is an error, both fileCount and usedCapacity are -1.
 */
+ (void)getUsage:(LCUsageResultBlock)block;

#pragma mark -
/*! @name Copy Private Files */

/**
 *  Copys a file to another remote path.
 *
 *  @param dstPath The destination remote path.
 *  @param block   Block should have the following argument signature: (LCPrivateFile *newFile, NSError *error)
 */
- (void)copyToPathInBackground:(NSString *)dstPath block:(LCPrivateFileResultBlock)block;

/**
 *  Copys a collection of private files at `scrPaths` to remote paths `dstPaths`. The result will pass in the `block`.
 *  The block has three parameters: `isAllCompleted` indicates whether all files was copied; `completed` contains an array of path pairs which was copied successfully, its structure: [{"from":scrPath, "to":dstPath}]; `error` is nil unless the network request failed or `scrPaths` does not match with `dstPaths`.
 *
 *  @param scrPaths        An array of private file remote path.
 *  @param dstPaths        An orderedSet of destination remote path. These paths must match with scrPaths.
 *  @param block           Block should have the following argument signature: (BOOL isAllCompleted, NSArray *completed, NSError *error)
 */
+ (void)copyAllInBackground:(NSArray *)scrPaths toPaths:(NSOrderedSet *)dstPaths block:(void(^)(BOOL isAllCompleted, NSArray *completed, NSError *error))block;

#pragma mark -
/*! @name Move Private Files */

/**
 *  Moves a file to another remote path.
 *
 *  @param dstPath The destination remote path.
 *  @param block   Block should have the following argument signature: (LCPrivateFile *newFile, NSError *error)
 */
- (void)moveToPathInBackground:(NSString *)dstPath block:(LCBooleanResultBlock)block;

/**
 *  Moves a collection of private files at `scrPaths` to remote paths `dstPaths`. The result will pass in the `block`.
 *  The block has three parameters: `isAllCompleted` indicates whether all files was moved; `completed` contains an array of path pairs which was copied successfully, its structure: [{"from":scrPath, "to":dstPath}]; `error` is nil unless the network request failed or `scrPaths` does not match with `dstPaths`.
 *
 *  @param scrPaths        An array of private file remote path.
 *  @param dstPaths        An orderedSet of destination remote path. These paths must match with `scrPaths`.
 *  @param block           Block should have the following argument signature: (BOOL isAllCompleted, NSArray *completed, NSError *error)
 */
+ (void)moveAllInBackground:(NSOrderedSet *)scrPaths toPaths:(NSOrderedSet *)dstPaths block:(void(^)(BOOL isAllCompleted, NSArray *completed, NSError *error))block;

#pragma mark -
/*! @name Create Folder */

/**
 *  Create a folder at remote path file.remotePath.
 *
 *  @param path  The remote path of a directory.
 *  @param block Block should have the following argument signature: (BOOL success, NSError *error)
 */
+ (void)createFolderAtPathInBackground:(NSString *)path block:(LCPrivateFileResultBlock)block;

#pragma mark -
/*! @name Share (Mock) */

/**
 *  Share a file or directory. (Mock)
 *
 *  @param block Block should have the following argument signature: (BOOL success, NSError *error)
 */
- (void)shareInBackgroundWithBlock:(LCBooleanResultBlock)block;

@end

