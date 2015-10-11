//
//  LCEntityACL.h
//  LeapCloud
//
//  Created by Sun Jin on 6/30/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCUser, LCRole;

/**
 *  A LCACL is used to control which users can access or modify a particular object. Each LCObject can have its own LCACL. You can grant read and write permissions separately to specific users, to groups of users that belong to roles, or you can grant permissions to "the public" so that, for example, any user could read a particular object but only a particular set of users could write to that object.
 */
@interface LCACL : NSObject <NSCopying, NSCoding>

/** @name Creating an ACL */

/*!
 Creates an ACL with no permissions granted.
 */
+ (LCACL *)ACL;

/*!
 Creates an ACL where only the provided user has access.
 
 @param user A user to assign read and wirte access.
 
 @return An ACL object where only the user has access.
 */
+ (LCACL *)ACLWithUser:(LCUser *)user;

/** @name Controlling Public Access */

/*!
 Set whether the public is allowed to read this object.
 
 @param allowed allowed or not
 */
- (void)setPublicReadAccess:(BOOL)allowed;

/*!
 Gets whether the public is allowed to read this object.
 
 @return YES if the public has read access, NO otherwise.
 */
- (BOOL)getPublicReadAccess;

/*!
 Set whether the public is allowed to write this object.
 
 @param allowed allowed or not
 */
- (void)setPublicWriteAccess:(BOOL)allowed;

/*!
 Gets whether the public is allowed to write this object.
 
 @return YES if the public has write access, NO otherwise.
 */
- (BOOL)getPublicWriteAccess;

/** @name Controlling Access Per-User */

/*!
 Set whether the given user id is allowed to read this object.
 
 @param allowed allowed or not
 @param userId The objectId of a user.
 */
- (void)setReadAccess:(BOOL)allowed forUserId:(NSString *)userId;

/*!
 Gets whether the given user id is *explicitly* allowed to read this object. Even if this returns NO, the user may still be able to access it if getPublicReadAccess returns YES or if the user belongs to a role that has access.
 
 @param userId The objectId of a user.
 
 @return YES if the user has read access. NO otherwise.
 */
- (BOOL)getReadAccessForUserId:(NSString *)userId;

/*!
 Set whether the given user id is allowed to write this object.
 
 @param allowed allowed or not
 @param userId The objectId of a user.
 */
- (void)setWriteAccess:(BOOL)allowed forUserId:(NSString *)userId;

/*!
 Gets whether the given user id is *explicitly* allowed to write this object. Even if this returns NO, the user may still be able to write it if getPublicWriteAccess returns YES or if the user belongs to a role that has access.
 
 @param userId The objectId of a user.
 
 @return YES if the user has write access. NO otherwise.
 */
- (BOOL)getWriteAccessForUserId:(NSString *)userId;

/*!
 Set whether the given user is allowed to read this object.
 
 @param allowed allowed or not
 @param user The user to assign access.
 */
- (void)setReadAccess:(BOOL)allowed forUser:(LCUser *)user;

/*!
 Gets whether the given user is *explicitly* allowed to read this object. Even if this returns NO, the user may still be able to access it if getPublicReadAccess returns YES or if the user belongs to a role that has access.
 
 @param user A user.
 
 @return YES if the user has read access. NO otherwise.
 */
- (BOOL)getReadAccessForUser:(LCUser *)user;

/*!
 Set whether the given user is allowed to write this object.
 
 @param allowed allowed or not
 @param user The user to assign access.
 */
- (void)setWriteAccess:(BOOL)allowed forUser:(LCUser *)user;

/*!
 Gets whether the given user is *explicitly* allowed to write this object. Even if this returns NO, the user may still be able to write it if getPublicWriteAccess returns YES or if the user belongs to a role that has access.
 
 @param user A user.
 
 @return YES if the user has write access. NO otherwise.
 */
- (BOOL)getWriteAccessForUser:(LCUser *)user;

/** @name Controlling Access Per-Role */

/*!
 Get whether users belonging to the role with the given name are allowed to read this object. Even if this returns false, the role may still be able to read it if a parent role has read access.
 
 @param name The name of a role.
 
 @return YES if the role has read access. NO otherwise.
 */
- (BOOL)getReadAccessForRoleWithName:(NSString *)name;

/*!
 Set whether users belonging to the role with the given name are allowed to read this object.
 
 @param allowed allowed or not
 @param name The name of a role.
 */
- (void)setReadAccess:(BOOL)allowed forRoleWithName:(NSString *)name;

/*!
 Get whether users belonging to the role with the given name are allowed to write this object. Even if this returns false, the role may still be able to write it if a parent role has write access.
 
 @param name The name of a role.
 @return YES if the role has read access. NO otherwise.
 */
- (BOOL)getWriteAccessForRoleWithName:(NSString *)name;

/*!
 Set whether users belonging to the role with the given name are allowed to write this object.
 
 @param allowed allowed or not
 @param name    The name of a role.
 */
- (void)setWriteAccess:(BOOL)allowed forRoleWithName:(NSString *)name;

/*!
 Get whether users belonging to the given role are allowed to read this object. Even if this returns NO, the role may still be able to read it if a parent role has read access. The role must already be saved on the server and its data must have been fetched in order to use this method.
 
 @param role A role.
 
 @return YES if the role has read access. NO otherwise.
 */
- (BOOL)getReadAccessForRole:(LCRole *)role;

/*!
 Set whether users belonging to the given role are allowed to read this object. The role must already be saved on the server and its data must have been fetched in order to use this method.
 
 @param role    The role to assign access.
 @param allowed Whether the given role can read this object.
 */
- (void)setReadAccess:(BOOL)allowed forRole:(LCRole *)role;

/*!
 Get whether users belonging to the given role are allowed to write this object. Even if this returns NO, the role may still be able to write it if a parent role has write access. The role must already be saved on the server and its data must have been fetched in order to use this method.
 
 @param role The name of the role.
 
 @return YES if the role has write access. NO otherwise.
 */
- (BOOL)getWriteAccessForRole:(LCRole *)role;

/*!
 Set whether users belonging to the given role are allowed to write this object. The role must already be saved on the server and its data must have been fetched in order to use this method.
 
 @param allowed allowed or not
 @param role    The role to assign access.
 */
- (void)setWriteAccess:(BOOL)allowed forRole:(LCRole *)role;

/** @name Setting Access Defaults */

/*!
 Sets a default ACL that will be applied to all LCObjects when they are created.
 
 @param acl                 The ACL to use as a template for all LCObjects created after setDefaultACL has been called. This value will be copied and used as a template for the creation of new ACLs, so changes to the instance after setDefaultACL has been called will not be reflected in new LCObjects.
 @param currentUserAccess   If true, the LCACL that is applied to newly-created LCObjects will provide read and write access to the currentUser at the time of creation. If false, the provided ACL will be used without modification. If acl is nil, this value is ignored.
 */
+ (void)setDefaultACL:(LCACL *)acl withAccessForCurrentUser:(BOOL)currentUserAccess;

/*!
 Sets a default ACL that will be applied to all LCObjects when they are created.
 
 @param acl     The ACL to use as a template for all LCObjects created after setDefaultACL has been called. This value will be copied and used as a template for the creation of new ACLs, so changes to the instance after setDefaultACL has been called will not be reflected in new LCObjects.
 @param allowed If true, the LCACL that is applied to newly-created LCObjects will provide read and write access to the `user` at the time of creation.  If false, the provided ACL will be used without modification. If acl is nil or user is unsaved, this value is ignored.
 @param user    The user must already be saved on the server.
 */
+ (void)setDefaultACL:(LCACL *)acl withAccess:(BOOL)allowed forUser:(LCUser *)user;

@end
