//
//  LCCloudParam.h
//  LeapCloud
//
//  Created by Sun Jin on 7/25/14.
//  Copyright (c) 2014 iLegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This class help you get cloud parameters.
 */
@interface LCCloudParam : NSObject

/**
 *  Enable to auto-refresh cloud parameter.
 */
+ (void)enable __deprecated_msg("please use LCConfig instead");

/**
 *  Refresh cloud parameter cache. Cloud paramete cache cannot auto-refresh, you can call this method to refresh them.
 */
+ (void)refresh __deprecated_msg("please use LCConfig instead");

+ (NSString *)getValueWithName:(NSString *)paramName defaultValue:(NSString *)defaultValue __deprecated_msg("please use LCConfig instead");
+ (NSInteger)getIntValueWithName:(NSString *)paramName defaultValue:(NSInteger)defaultValue __deprecated_msg("please use LCConfig instead");
+ (BOOL)getBooleanValueWithName:(NSString *)paramName defaultValue:(BOOL)defaultValue __deprecated_msg("please use LCConfig instead");

/*
 * The handler will be excuted every time after cloud parameter was refreshed.
 */
+ (void)addObserverWithIdentifier:(id)identifier handler:(void(^)(void))handler __deprecated_msg("please use LCConfig instead");

/*
 * Remove the handler added with the identifier.
 */
+ (void)removeObserverWithIdentifier:(id)identifier __deprecated_msg("please use LCConfig instead");

@end
