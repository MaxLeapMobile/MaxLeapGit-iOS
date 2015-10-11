//
//  LCObject+Subclass.h
//  LeapCloud
//
//  Created by Sun Jin on 7/7/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#ifdef EXTENSION_IOS
    #import <LeapCloudExt/LCObject.h>
#else
    #import <LeapCloud/LCObject.h>
#endif

@class LCQuery;

/*!
 <h3>Subclassing Notes</h3>
 
 Developers can subclass LCObject for a more native object-oriented class structure. Strongly-typed subclasses of LCObject must conform to the LCSubclassing protocol and must call registerSubclass to be returned by LCQuery and other LCObject factories. All methods in LCSubclassing except for +[LCSubclassing leapClassName] are already implemented in the LCObject(Subclass) category. Inculding LCObject+Subclass.h in your implementation file provides these implementations automatically.<br>
 
 Subclasses support simpler initializers, query syntax, and dynamic synthesizers. The following shows an example subclass:<br>
 
    @interface MYGame : LCObject< LCSubclassing >
 
    // Accessing this property is the same as objectForKey:@"title"
    @property (retain) NSString *title;
 
    + (NSString *)leapClassName;
 
    @end
 
    @implementation MYGame
 
    @dynamic title;
 
    + (NSString *)leapClassName {
        return @"Game";
    }
 
    @end
 
    MYGame *game = [[MYGame alloc] init];
    game.title = @"Bughouse";
    [LCDataManager saveObjectInBackground:game block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
 
        } else {
 
        }
    }];
 */
@interface LCObject (Subclass)

/*! @name Methods for Subclasses */

/*!
 Designated initializer for subclasses.<br>
 This method can only be called on subclasses which conform to LCSubclassing.<br>
 This method should not be overridden.
 */
- (id)init;

/*!
 Creates an instance of the registered subclass with this class's leapClassName.<br>
 
 This helps a subclass ensure that it can be subclassed itself. For example, [LCUser object] will return a MyUser object if MyUser is a registered subclass of LCUser. For this reason, [MyClass object] is preferred to [[MyClass alloc] init].<br>
 
 This method can only be called on subclasses which conform to LCSubclassing.<br>
 
 A default implementation is provided by LCObject which should always be sufficient.
 */
+ (instancetype)object;

/*! The name of the class as seen in the REST API. */
+ (NSString *)leapClassName;

/*!
 Creates a reference to an existing LCObject for use in creating associations between LCObjects.  Calling isDataAvailable on this object will return NO until fetchIfNeeded has been called.  No network request will be made.<br>
 
 This method can only be called on subclasses which conform to LCSubclassing.<br>
 
 A default implementation is provided by LCObject which should always be sufficient.
 
 @param objectId The object id for the referenced object.
 @return A LCObject without data.
 */
+ (id)objectWithoutDataWithObjectId:(NSString *)objectId;

/*!
 Registers an Objective-C class for LeapCloud to use for representing a given LeapCloud class.<br>
 
 Once this is called on a LCObject subclass, any LCObject LeapCloud creates with a class name matching [self leapClassName] will be an instance of subclass.<br>
 
 This method can only be called on subclasses which conform to LCSubclassing.<br>
 
 A default implementation is provided by LCObject which should always be sufficient.
 */
+ (void)registerSubclass;

/*!
 Returns a query for objects of type +leapClassName.<br>
 
 This method can only be called on subclasses which conform to LCSubclassing.<br>
 
 A default implementation is provided by LCObject which should always be sufficient.
 */
+ (LCQuery *)query;

@end
