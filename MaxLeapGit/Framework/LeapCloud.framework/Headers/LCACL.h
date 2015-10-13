//
//  LCACL.h
//  LeapCloud
//
//  Created by Sun Jin on 6/30/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const LCAccessTypeOrgUser;
FOUNDATION_EXPORT NSString * const LCAccessTypeMasterKey;
FOUNDATION_EXPORT NSString * const LCAccessTypeAppUser;
FOUNDATION_EXPORT NSString * const LCAccessTypeAPIKey;

/**
 *  A LCACL is used to control which users can access or modify a particular object. Each LCObject can have its own LCACL. You can grant read and write permissions separately to specific users, to groups of users that belong to roles, or you can grant permissions to "the public" so that, for example, any user could read a particular object but only a particular set of users could write to that object.
 */
@interface LCACL : NSObject <NSCopying, NSCoding>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (NSString *)accessType;
- (NSString *)userId;
- (NSString *)appUserId;
- (NSString *)orgUserId;

@end
