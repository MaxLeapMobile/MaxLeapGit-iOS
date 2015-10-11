//
//  LCRelation.h
//  LeapCloud
//
//  Created by Sun Jin on 6/23/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCQuery, LCObject;

/*!
 A class that is used to access all of the children of a many-to-many relationship. Each instance of LCRelation is associated with a particular parent object and key.
 */
@interface LCRelation : NSObject

@property (readonly, nonatomic, strong) NSString *targetClass;


#pragma mark Accessing objects
/*!
 @return A LCQuery that can be used to get objects in this relation.
 */
- (LCQuery *)query;


#pragma mark Modifying relations

/*!
 Adds a relation to the passed in object.
 
 @param object LCObject to add relation to.
 */
- (void)addObject:(LCObject *)object;

/*!
 Removes a relation to the passed in object.
 
 @param object LCObject to add relation to.
 */
- (void)removeObject:(LCObject *)object;

@end
