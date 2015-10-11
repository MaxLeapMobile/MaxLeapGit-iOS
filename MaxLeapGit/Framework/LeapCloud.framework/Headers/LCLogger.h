//
//  LCLogger.h
//  LeapCloud
//
//  Created by Sun Jin on 8/18/15.
//  Copyright (c) 2015 leap. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  `LCLogLevel` enum specifies different levels of logging that could be used to limit or display more messages in logs.
 */
typedef NS_ENUM(int, LCLogLevel){
    /**
     *  Log level that disables all logging.
     */
    LCLogLevelNone = 0,
    /**
     *  Log level that allows error messages to the log.
     */
    LCLogLevelError = 1,
    /**
     *  Log level that allows the following messages to the log:
     *  - Errors
     *  - Warnings
     */
    LCLogLevelWarning = 2,
    /**
     *  Log level that allows the following messages to the log:
     *  - Errors
     *  - Warnings
     *  - Infomational messages
     */
    LCLogLevelInfo = 3,
    /**
     *  Log level that allows the following messages to the log:
     *  - Errors
     *  - Warnings
     *  - Infomational messages
     *  - Debug messages
     */
    LCLogLevelDebug = 4
};
/**
 *  `LCLogger` used to display logs.
 */
@interface LCLogger : NSObject

/**
 *  Current logger that will be used to display log messages.
 *
 *  @return the current logger
 */
+ (LCLogger *)currentLogger;

/**
 *  Set the custom logger.
 *
 *  By default, an instance of `LCLogger` is used.
 *
 *  @param logger Logger to set
 */
+ (void)setCurrentLogger:(LCLogger *)logger;

/**
 *  Sets the level of logging to display.
 *
 *  @discussion By default:
 *  - If running inside an app that was downloaded from iOS App Store, it is set to `LCLogLevelNone`.
 *  - All other cases, it is set to `LCLogLevelWarning`.
 *
 *  @param level Log level to set
 */
+ (void)setLogLevel:(LCLogLevel)level;

/**
 *  Log level that will be displayed.
 *
 *  @discussion By default:
 *  - If running inside an app that was downloaded from iOS App Store, it is set to `LCLogLevelNone`.
 *  - All other cases, it is set to `LCLogLevelWarning`.
 *
 *  @return The current log level.
 */
+ (LCLogLevel)logLevel;

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
- (void)logMsg_va:(NSString *)tag level:(LCLogLevel)level format:(NSString *)format args:(va_list)args;

@end

/**
 *  Display a log message at a specific level for a tag using current logger.
 *
 *  @param tag    Logging tag
 *  @param level  Logging level
 *  @param format Format to use for the log message
 *  @param ...    Log message arguments
 */
FOUNDATION_EXPORT void LCLogMessageTo(NSString *tag, LCLogLevel level, NSString *format, ...) NS_FORMAT_FUNCTION(3, 4);

/**
 *  Display a log message at a specific level for a tag using current logger.
 *
 *  @param tag          Logging tag
 *  @param level        Logging level
 *  @param functionName The function name that logging this message
 *  @param format       Format to use for the log message
 *  @param ...          Log message arguments
 */
FOUNDATION_EXPORT void LCLogMessageToF(NSString *tag, LCLogLevel level, const char *functionName, NSString *format, ...) NS_FORMAT_FUNCTION(4, 5);


