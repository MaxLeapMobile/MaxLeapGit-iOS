//
//  MLLogger.h
//  MaxLeap
//
//  Created by Sun Jin on 8/18/15.
//  Copyright (c) 2015 leap. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  `MLLogLevel` enum specifies different levels of logging that could be used to limit or display more messages in logs.
 */
typedef NS_ENUM(int, MLLogLevel){
    /**
     *  Log level that disables all logging.
     */
    MLLogLevelNone = 0,
    /**
     *  Log level that allows error messages to the log.
     */
    MLLogLevelError = 1,
    /**
     *  Log level that allows the following messages to the log:
     *  - Errors
     *  - Warnings
     */
    MLLogLevelWarning = 2,
    /**
     *  Log level that allows the following messages to the log:
     *  - Errors
     *  - Warnings
     *  - Infomational messages
     */
    MLLogLevelInfo = 3,
    /**
     *  Log level that allows the following messages to the log:
     *  - Errors
     *  - Warnings
     *  - Infomational messages
     *  - Debug messages
     */
    MLLogLevelDebug = 4
};
/**
 *  `MLLogger` used to display logs.
 */
@interface MLLogger : NSObject

/**
 *  Current logger that will be used to display log messages.
 *
 *  @return the current logger
 */
+ (MLLogger *)currentLogger;

/**
 *  Set the custom logger.
 *
 *  By default, an instance of `MLLogger` is used.
 *
 *  @param logger Logger to set
 */
+ (void)setCurrentLogger:(MLLogger *)logger;

/**
 *  Sets the level of logging to display.
 *
 *  @discussion By default:
 *  - If running inside an app that was downloaded from iOS App Store, it is set to `MLLogLevelNone`.
 *  - All other cases, it is set to `MLLogLevelWarning`.
 *
 *  @param level Log level to set
 */
+ (void)setLogLevel:(MLLogLevel)level;

/**
 *  Log level that will be displayed.
 *
 *  @discussion By default:
 *  - If running inside an app that was downloaded from iOS App Store, it is set to `MLLogLevelNone`.
 *  - All other cases, it is set to `MLLogLevelWarning`.
 *
 *  @return The current log level.
 */
+ (MLLogLevel)logLevel;

/**
 *  Display a log message at a specific level for a tag using `NSLog()`.
 *  If current logging level doesn't include this level, this method does nothing.
 *
 *  @discussion Subclasses can overide this method to implement your own logging method.
 *
 *  @param tag    Logging tag
 *  @param level  Longging Level
 *  @param format Format to use for the log message
 *  @param args   Log message arguments.
 */
- (void)logMsg_va:(NSString *)tag level:(MLLogLevel)level format:(NSString *)format args:(va_list)args;

@end

/**
 *  Display a log message at a specific level for a tag using current logger.
 *
 *  @param tag    Logging tag
 *  @param level  Logging level
 *  @param format Format to use for the log message
 *  @param ...    Log message arguments
 */
FOUNDATION_EXPORT void MLLogMessageTo(NSString *tag, MLLogLevel level, NSString *format, ...) NS_FORMAT_FUNCTION(3, 4);

/**
 *  Display a log message at a specific level for a tag using current logger.
 *
 *  @param tag          Logging tag
 *  @param level        Logging level
 *  @param functionName The function name that logging this message
 *  @param format       Format to use for the log message
 *  @param ...          Log message arguments
 */
FOUNDATION_EXPORT void MLLogMessageToF(NSString *tag, MLLogLevel level, const char *functionName, NSString *format, ...) NS_FORMAT_FUNCTION(4, 5);


