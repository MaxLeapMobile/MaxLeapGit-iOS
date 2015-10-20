//
//  MLGMGene+CoreDataProperties.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/11.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MLGMGene.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGMGene (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *maxLeapID;
@property (nullable, nonatomic, retain) NSString *language;
@property (nullable, nonatomic, retain) NSString *skill;
@property (nullable, nonatomic, retain) NSDate *updateTime;
@property (nullable, nonatomic, retain) MLGMActorProfile *userProfile;

@end

NS_ASSUME_NONNULL_END
