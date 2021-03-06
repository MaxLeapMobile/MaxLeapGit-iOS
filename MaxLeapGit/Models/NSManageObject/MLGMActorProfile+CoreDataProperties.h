//
//  MLGMUserProfile+CoreDataProperties.h
//  MaxLeapGit
//
//  Created by Michael on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MLGMActorProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLGMActorProfile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *avatarUrl;
@property (nullable, nonatomic, retain) NSString *blog;
@property (nullable, nonatomic, retain) NSString *company;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSNumber *followerCount;
@property (nullable, nonatomic, retain) NSNumber *followingCount;
@property (nullable, nonatomic, retain) NSDate *githubCreatTime;
@property (nullable, nonatomic, retain) NSNumber *githubId;
@property (nullable, nonatomic, retain) NSDate *githubUpdateTime;
@property (nullable, nonatomic, retain) NSNumber *hireable;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *loginName;
@property (nullable, nonatomic, retain) NSString *nickName;
@property (nullable, nonatomic, retain) NSNumber *publicRepoCount;
@property (nullable, nonatomic, retain) NSNumber *organizationCount;
@property (nullable, nonatomic, retain) NSNumber *starCount;
@property (nullable, nonatomic, retain) NSString *introduction;
@property (nullable, nonatomic, retain) NSSet<MLGMGene *> *genes;

@end

@interface MLGMActorProfile (CoreDataGeneratedAccessors)

- (void)addGenesObject:(MLGMGene *)value;
- (void)removeGenesObject:(MLGMGene *)value;
- (void)addGenes:(NSSet<MLGMGene *> *)values;
- (void)removeGenes:(NSSet<MLGMGene *> *)values;

@end

NS_ASSUME_NONNULL_END
