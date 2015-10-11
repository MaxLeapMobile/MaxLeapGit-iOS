//
//  MLGMEvent.h
//  MaxLeapGit
//
//  Created by Jun Xia on 15/10/12.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLGMEvent : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)fillObject:(NSDictionary *)object;
@end

NS_ASSUME_NONNULL_END

#import "MLGMEvent+CoreDataProperties.h"
