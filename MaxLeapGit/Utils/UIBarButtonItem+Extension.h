//
//  UIBarButtonItem+Custom.h
//  iKeyboard
//
//  Created by XiaJun on 15/4/3.
//  Copyright (c) 2015年 MaxLeapMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MFLMExtension)
+ (UIBarButtonItem *)barButtonItemWithNormalImagenName:(NSString *)normalImageName
                                     selectedImageName:(NSString *)selectedImageName
                                                target:(id)taget
                                                action:(SEL)action;
@end
