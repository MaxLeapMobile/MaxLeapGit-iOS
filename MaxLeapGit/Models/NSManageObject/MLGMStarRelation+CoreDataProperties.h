//
//  MLGMStarRelation+CoreDataProperties.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/16.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MLGMStarRelation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGMStarRelation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *loginName;
@property (nullable, nonatomic, retain) NSString *repoName;
@property (nullable, nonatomic, retain) NSNumber *isStar;

@end

NS_ASSUME_NONNULL_END
