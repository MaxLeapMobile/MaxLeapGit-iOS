//
//  LCAnalytics.h
//  LeapCloud
//
//  Created by Sun Jin on 7/10/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 LCAnalytics provides an interface toLeapCloud's logging and analytics backend.<br>
 <br>
 Methods will return immediately and cache the request (+ timestamp) to be handled "eventually." That is, the request will be sent immediately if possible or the next time a network connection is available otherwise.
 */
@interface LCAnalytics : NSObject

#pragma mark -

/**
 *  Set the timeout for expiring a LeapCloud session.
 *
 *  This is an optional method that sets the time the app may be in the background before
 *  starting a new session upon resume.  The default value for the session timeout is 0
 *  seconds in the background.
 *
 *  @param seconds The time in seconds to set the session timeout to.
 */
+ (void)setSessionContinueSeconds:(int)seconds;

#pragma mark -
/** @name Custom Analytics */

/*!
 Tracks the occurrence of a custom event. LeapCloud will store a data point at the time of invocation with the given event name.
 
 @param name The name of the custom event to report to LeapCloud as having happened.
 */
+ (void)trackEvent:(NSString *)name;

/**
 *  Tracks the occurrence of a custom event. LeapCloud will store a data point at the time of invocation with the given event name.
 *
 *  @param name  The name of the custom event to report to LeapCloud as having happened.
 *  @param count The number of this event occurred.
 */
+ (void)trackEvent:(NSString *)name count:(int)count;

/**
 *  Tracks the occurrence of a custom event with additional dimensions. LeapCloud will store a data point at the time of invocation with the given event name.<br>
 *
 *  Dimensions will allow segmentation of the occurrences of this custom event. Keys and values should be NSStrings, and will throw otherwise.<br>
 *
 *  To track a user signup along with additional metadata, consider the following:<br>
 *
 *  @code
 *  NSDictionary *dimensions = @{@"gender": @"m",
 *                               @"source": @"web",
 *                               @"dayType": @"weekend" };
 *  [LCAnalytics trackEvent:@"signup" dimensions:dimensions];
 *  @endcode
 *
 *  @param name       The name of the custom event to report to LeapCloud as having happened.
 *  @param dimensions The dictionary of information by which to segment this event.
 */
+ (void)trackEvent:(NSString *)name dimensions:(NSDictionary *)dimensions;

/**
 *  Tracks the occurrence of a custom event with additional dimensions and the count it occurred. LeapCloud will store a data point at the time of invocation with the given event name.<br>
 *
 *  Dimensions will allow segmentation of the occurrences of this custom event. Keys and values should be NSStrings, and will throw otherwise.<br>
 *
 *  To track a user signup along with additional metadata, consider the following:<br>
 *
 *  @code
 *  NSDictionary *dimensions = @{@"gender": @"m",
 *                               @"source": @"web",
 *                               @"dayType": @"weekend" };
 *  [LCAnalytics trackEvent:@"signup" dimensions:dimensions count:1];
 *  @endcode
 *
 *  @param name       The name of the custom event to report to LeapCloud as having happened.
 *  @param dimensions The dictionary of information by which to segment this event.
 *  @param count      The number of this event occurred.
 */
+ (void)trackEvent:(NSString *)name dimensions:(NSDictionary *)dimensions count:(int)count;

#pragma mark -
/** @name Page View Analytics */

/**
 *  Tracks the duration of view displayed.
 *
 *  Tracks the beginning of view display.
 *
 *  @param pageName The name of the page.
 */
+ (void)beginLogPageView:(NSString *)pageName;

/**
 *  Tracks the duration of view displayed.
 *
 *  Tracks the ending of view display.
 *
 *  @param pageName The name of the page.
 */
+ (void)endLogPageView:(NSString *)pageName;

@end
