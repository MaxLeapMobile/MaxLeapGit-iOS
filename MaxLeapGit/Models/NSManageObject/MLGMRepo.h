//
//  MLGMRepo.h
//  MaxLeapGit
//
//  Created by Michael on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLGMRepo : NSManagedObject
- (void)fillObject:(NSDictionary *)object;
- (void)fillRecommendationObject:(NSDictionary *)object;
@end

NS_ASSUME_NONNULL_END

#import "MLGMRepo+CoreDataProperties.h"
