//
//  LCSdkServiceManager.h
//  LeapCloud
//
//  Created by Sun Jin on 15/3/26.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ILSLeapCloud/LCSdkService.h>

@interface LCSdkServiceManager : NSObject

+ (void)registerService:(id<LCSdkService>)service;
+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
+ (BOOL)handleLaunchOptions:(NSDictionary *)launchOptions;

@end
