//
//  MLSubclassing.h
//  MaxLeap
//
//  Created by Sun Jin on 7/7/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLQuery;

/*!
 If a subclass of MLObject conforms to MLSubclassing and calls registerSubclass, MaxLeap will be able to use that class as the native class for a MaxLeap object.<br>
 
 Classes conforming to this protocol should subclass MLObject and include MLObject+Subclass.h in their implementation file. This ensures the methods in the Subclass category of MLObject are exposed in its subclasses only.
 */
@protocol MLSubclassing <NSObject>

/*!
 Constructs an object of the most specific class known to implement +leapClassName. This method takes care to help MLObject subclasses be subclassed themselves. For example, [MLUser object] returns a MLUser by default but will return an object of a registered subclass instead if one is known. A default implementation is provided by MLObject which should always be sufficient.
 
 @return Returns the object that is instantiated.
 */
+ (instancetype)object;

/*!
 Creates a reference to an existing MLObject for use in creating associations between MLObjects.  Calling isDataAvailable on this object will return NO until fetchIfNeeded or refresh has been called.  No network request will be made. A default implementation is provided by MLObject which should always be sufficient.
 
 @param objectId The object id for the referenced object.
 @return A MLObject without data.
 */
+ (instancetype)objectWithoutDataWithObjectId:(NSString *)objectId;

/*! The name of the class as seen in the REST API. */
+ (NSString *)leapClassName;

/*!
 Create a query which returns objects of this type.<br>
 A default implementation is provided by MLObject which should always be sufficient.
 */
+ (MLQuery *)query;

/*!
 Lets MaxLeap know this class should be used to instantiate all objects with class type leapClassName.<br>
 This method must be called before +[MaxLeap setApplicationId:clientKey:site:]
 */
+ (void)registerSubclass;

@end
