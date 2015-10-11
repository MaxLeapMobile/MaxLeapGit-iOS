//
//  LCGAMission.h
//  LeapCloud
//
//  Created by Sun Jin on 6/24/15.
//  Copyright (c) 2015 leap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCGAMission : NSObject

+ (void)onBegin:(NSString *)missionId type:(NSString *)type;

+ (void)onPause:(NSString *)missionId;
+ (void)pauseAll;

+ (void)onResume:(NSString *)missionId;
+ (void)resumeAll;

+ (void)onCompleted:(NSString *)missionId;

+ (void)onFailed:(NSString *)missionId failedCause:(NSString *)cause;

@end
