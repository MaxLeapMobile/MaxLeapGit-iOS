//
//  MethodSwizzler.h
//  ILSLeapCloud
//
//  Created by Sun Jin on 6/5/15.
//  Copyright (c) 2015 Leapas. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT BOOL ILSLCSwizzleMethod(Class c, SEL origSEL, SEL newSEL);

FOUNDATION_EXPORT BOOL ILSLCSwizzleInstanceMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block);

FOUNDATION_EXPORT BOOL ILSLCSwizzleClassMethod(Class c, SEL origSEL, SEL newSEL);

FOUNDATION_EXPORT BOOL ILSLCSwizzleClassMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block);


