//
//  MLGMTagRelation+CoreDataProperties.h
//  MaxLeapGit
//
//  Created by Michael on 15/10/16.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MLGMTagRelation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGMTagRelation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *loginName;
@property (nullable, nonatomic, retain) NSString *repoName;
@property (nullable, nonatomic, retain) NSNumber *isStarred;
@property (nullable, nonatomic, retain) NSNumber *isTagged;//== YES if the user starred, unstarred or forked the repo

@end

NS_ASSUME_NONNULL_END
