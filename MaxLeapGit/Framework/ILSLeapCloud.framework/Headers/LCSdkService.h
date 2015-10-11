//
//  LCSdkService.h
//  LeapCloud
//
//  Created by Sun Jin on 15/3/26.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCSdkService <NSObject>

- (NSString *)name; // 服务名字，需要保证全局唯一
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

@end
