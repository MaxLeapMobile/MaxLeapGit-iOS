//
//  MLGMUserProfile.h
//  MaxLeapGit
//
//  Created by Michael on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MLGMGene;

NS_ASSUME_NONNULL_BEGIN

@interface MLGMActorProfile : NSManagedObject

- (void)fillProfile:(NSDictionary *)object;
- (void)fillFollow:(NSDictionary *)object;
- (void)fillOrg:(NSDictionary *)object;
- (void)fillSearchResult:(NSDictionary *)object;
@end

NS_ASSUME_NONNULL_END

#import "MLGMActorProfile+CoreDataProperties.h"
