//
//  MLRelation.h
//  MaxLeap
//


#import <Foundation/Foundation.h>

@class MLQuery, MLObject;

/*!
 A class that is used to access all of the children of a many-to-many relationship. Each instance of MLRelation is associated with a particular parent object and key.
 */
@interface MLRelation : NSObject

@property (readonly, nonatomic, strong) NSString *targetClass;


#pragma mark Accessing objects
/*!
 @return A MLQuery that can be used to get objects in this relation.
 */
- (MLQuery *)query;


#pragma mark Modifying relations

/*!
 Adds a relation to the passed in object.
 
 @param object MLObject to add relation to.
 */
- (void)addObject:(MLObject *)object;

/*!
 Removes a relation to the passed in object.
 
 @param object MLObject to add relation to.
 */
- (void)removeObject:(MLObject *)object;

@end
