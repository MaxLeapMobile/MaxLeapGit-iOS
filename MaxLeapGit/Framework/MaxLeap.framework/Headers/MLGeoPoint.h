//
//  MLGeoPoint.h
//  MaxLeap
//
//  Created by Sun Jin on 6/30/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*!
 Object which may be used to embed a latitude / longitude point as the value for a key in a MLObject. MLObjects with a MLGeoPoint field may be queried in a geospatial manner using MLQuery's whereKey:nearGeoPoint:.<br>
 
 This is also used as a point specifier for whereKey:nearGeoPoint: queries.<br>
 
 Currently, object classes may only have one key associated with a GeoPoint type.
 */
@interface MLGeoPoint : NSObject

/** @name Creating a MLGeoPoint */
/*!
 Create a MLGeoPoint object.  Latitude and longitude are set to 0.0.
 
 @return Returns a new MLGeoPoint.
 */
+ (MLGeoPoint *)geoPoint;

/*!
 Creates a new MLGeoPoint object for the given CLLocation, set to the location's coordinates.
 
 @param location CLLocation object, with set latitude and longitude.
 @return Returns a new MLGeoPoint at specified location.
 */
+ (MLGeoPoint *)geoPointWithLocation:(CLLocation *)location;

/*!
 Creates a new MLGeoPoint object with the specified latitude and longitude.
 
 @param latitude Latitude of point in degrees.
 @param longitude Longitude of point in degrees.
 
 @return New point object with specified latitude and longitude.
 */
+ (MLGeoPoint *)geoPointWithLatitude:(double)latitude longitude:(double)longitude;

/*!
 Fetches the user's current location and returns a new MLGeoPoint object via the provided block.
 
 @param geoPointHandler A block which takes the newly created MLGeoPoint as an argument.
 */
+ (void)geoPointForCurrentLocationInBackground:(void(^)(MLGeoPoint *geoPoint, NSError *error))geoPointHandler;

/** @name Controlling Position */

/// Latitude of point in degrees.  Valid range [-90.0, 90.0].
@property (nonatomic) double latitude;
/// Longitude of point in degrees.  Valid range [-180.0, 180.0].
@property (nonatomic) double longitude;

/** @name Calculating Distance */

/*!
 Get distance in radians from this point to specified point.
 
 @param point MLGeoPoint location of other point.
 @return distance in radians
 */
- (double)distanceInRadiansTo:(MLGeoPoint *)point;

/*!
 Get distance in miles from this point to specified point.
 
 @param point MLGeoPoint location of other point.
 @return distance in miles
 */
- (double)distanceInMilesTo:(MLGeoPoint *)point;

/*!
 Get distance in kilometers from this point to specified point.
 
 @param point MLGeoPoint location of other point.
 @return distance in kilometers
 */
- (double)distanceInKilometersTo:(MLGeoPoint *)point;

@end
