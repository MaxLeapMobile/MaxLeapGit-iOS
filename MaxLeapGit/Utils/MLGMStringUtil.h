//
//  GMStringUtil.h
//  MaxLeapGit
//
//  Created by Li Zhu on 15/10/9.
//  Copyright © 2015年 MaxLeapMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLGMStringUtil : NSObject
+ (CGSize)sizeInOneLineOfText:(NSString *)text font:(UIFont *)font;
+ (CGSize)sizeOfText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size;
@end
