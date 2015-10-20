//
//  INTULocationRequestDefines.h
//
//  Copyright (c) 2014 Intuit Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#ifndef INTU_LOCATION_REQUEST_DEFINES_H
#define INTU_LOCATION_REQUEST_DEFINES_H

#define kINTUHorizontalAccuracyThresholdCity            5000.0  // in meters
#define kINTUHorizontalAccuracyThresholdNeighborhood    1000.0  // in meters
#define kINTUHorizontalAccuracyThresholdBlock           100.0   // in meters
#define kINTUHorizontalAccuracyThresholdHouse           15.0    // in meters
#define kINTUHorizontalAccuracyThresholdRoom            5.0     // in meters

#define kINTUUpdateTimeStaleThresholdCity               600.0   // in seconds
#define kINTUUpdateTimeStaleThresholdNeighborhood       300.0   // in seconds
#define kINTUUpdateTimeStaleThresholdBlock              60.0    // in seconds
#define kINTUUpdateTimeStaleThresholdHouse              15.0    // in seconds
#define kINTUUpdateTimeStaleThresholdRoom               5.0     // in seconds


/**
 *  An abstraction of both the horizontal accuracy and recency of location data.<br>
 *  Room is the highest level of accuracy/recency; City is the lowest level.
 */
typedef NS_ENUM(NSInteger, INTULocationAccuracy) {
    /** Not valid as a desired accuracy. */
    /** Inaccurate (>5000 meters, received >10 minutes ago) */
    INTULocationAccuracyNone = 0,
    
    /* These options are valid desired accuracies. */
    /** 5000 meters or better, received within the last 10 minutes  -- lowest accuracy */
    INTULocationAccuracyCity,
    
    /** 1000 meters or better, received within the last 5 minutes */
    INTULocationAccuracyNeighborhood,
    
    /** 100 meters or better, received within the last 1 minute */
    INTULocationAccuracyBlock,
    
    /** 15 meters or better, received within the last 15 seconds */
    INTULocationAccuracyHouse,
    
    /** 5 meters or better, received within the last 5 seconds      -- highest accuracy */
    INTULocationAccuracyRoom,
};

typedef NS_ENUM(NSInteger, INTULocationStatus) {
    /* These statuses will accompany a valid location. */
    /** got a location and desired accuracy level was achieved successfully */
    INTULocationStatusSuccess = 0,
    
    /** got a location, but desired accuracy level was not reached before timeout */
    INTULocationStatusTimedOut,
    
    
    /* These statuses indicate some sort of error, and will accompany a nil location. */
    /** user has not responded to the permissions dialog */
    INTULocationStatusServicesNotDetermined,
    
    /** user has explicitly denied this app permission to access location services */
    INTULocationStatusServicesDenied,
    
    /** ser does not have ability to enable location services (e.g. parental controls, corporate policy, etc) */
    INTULocationStatusServicesRestricted,
    
    /** user has turned off device-wide location services from system settings */
    INTULocationStatusServicesDisabled,
    
    /** an error occurred while using the system location */
    INTULocationStatusError
};

/**
 A block type for a location request, which is executed when the request succeeds, fails, or times out.
 
 @param currentLocation     The most recent & accurate current location available when the block executes, or nil if no valid location is available.
 @param achievedAccuracy    The accuracy level that was actually achieved (may be better than, equal to, or worse than the desired accuracy).
 @param status              The status of the location request - whether it succeeded, timed out, or failed due to some sort of error. This can be used to understand what the outcome of the request was, decide if/how to use the associated currentLocation, and determine whether other actions are required (such as displaying an error message to the user, retrying with another request, quietly proceeding, etc).
 */
typedef void(^INTULocationRequestBlock)(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status);

#endif /* INTU_LOCATION_REQUEST_DEFINES_H */
