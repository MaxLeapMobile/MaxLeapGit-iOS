//
//  MLGMAccount+CoreDataProperties.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MLGMAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGMAccount (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *accessToken;
@property (nullable, nonatomic, retain) NSNumber *isOnline;
@property (nullable, nonatomic, retain) MLGMActorProfile *actorProfile;

@end

NS_ASSUME_NONNULL_END
