//
//  MLGMGene.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/11.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MLGMActorProfile;

NS_ASSUME_NONNULL_BEGIN

@interface MLGMGene : NSManagedObject

- (void)fillObject:(NSDictionary *)object;

@end

NS_ASSUME_NONNULL_END

#import "MLGMGene+CoreDataProperties.h"
