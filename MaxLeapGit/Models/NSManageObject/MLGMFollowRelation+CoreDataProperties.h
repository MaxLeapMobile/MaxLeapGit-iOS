//
//  MLGMFollowRelation+CoreDataProperties.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/15.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MLGMFollowRelation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGMFollowRelation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isFollow;
@property (nullable, nonatomic, retain) NSString *sourceLoginName;
@property (nullable, nonatomic, retain) NSString *targetLoginName;

@end

NS_ASSUME_NONNULL_END
