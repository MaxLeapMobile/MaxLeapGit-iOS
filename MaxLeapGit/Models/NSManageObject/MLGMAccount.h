//
//  MLGMAccount.h
//  MaxLeapGit
//
//  Created by Michael on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MLGMActorProfile;

NS_ASSUME_NONNULL_BEGIN

#define kOnlineAccount [MLGMAccount MR_findFirstByAttribute:@"isOnline" withValue:@(YES)]
#define kOnlineAccountProfile kOnlineAccount.actorProfile
#define kOnlineUserName kOnlineAccount.actorProfile.loginName

@interface MLGMAccount : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "MLGMAccount+CoreDataProperties.h"
