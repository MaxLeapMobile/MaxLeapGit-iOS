//
//  LCSubclassing.h
//  LeapCloud
//
//  Created by Sun Jin on 7/7/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCQuery;

/*!
 If a subclass of LCObject conforms to LCSubclassing and calls registerSubclass, LeapCloud will be able to use that class as the native class for a LeapCloud object.<br>
 
 Classes conforming to this protocol should subclass LCObject and include LCObject+Subclass.h in their implementation file. This ensures the methods in the Subclass category of LCObject are exposed in its subclasses only.
 */
@protocol LCSubclassing <NSObject>

/*!
 Constructs an object of the most specific class known to implement +leapClassName. This method takes care to help LCObject subclasses be subclassed themselves. For example, [LCUser object] returns a LCUser by default but will return an object of a registered subclass instead if one is known. A default implementation is provided by LCObject which should always be sufficient.
 
 @return Returns the object that is instantiated.
 */
+ (instancetype)object;

/*!
 Creates a reference to an existing LCObject for use in creating associations between LCObjects.  Calling isDataAvailable on this object will return NO until fetchIfNeeded or refresh has been called.  No network request will be made. A default implementation is provided by LCObject which should always be sufficient.
 
 @param objectId The object id for the referenced object.
 @return A LCObject without data.
 */
+ (instancetype)objectWithoutDataWithObjectId:(NSString *)objectId;

/*! The name of the class as seen in the REST API. */
+ (NSString *)leapClassName;

/*!
 Create a query which returns objects of this type.<br>
 A default implementation is provided by LCObject which should always be sufficient.
 */
+ (LCQuery *)query;

/*!
 Lets LeapCloud know this class should be used to instantiate all objects with class type leapClassName.<br>
 This method must be called before +[LeapCloud setApplicationId:clientKey:]
 */
+ (void)registerSubclass;

@end
