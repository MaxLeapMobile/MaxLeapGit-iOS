//
//  UIImage+Color.h
//  YouTubeMusic
//
//  Created by Eric on 11/1/13.
//  Copyright (c) 2013 Eric_Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, GradientdDirection) {
    Horizontal,
    Vertical,
    ForwardSlash,
    BackSlash
};

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color withRadius:(float)radius;
+ (UIImage *)imageWithColor:(UIColor *)color withEdgeLength:(NSUInteger)edgeLength;

/*! 渐变 */
+ (UIImage *)imageWithColors:(NSArray *)colors
                   imageSize:(CGSize)size
           gradientDirection:(GradientdDirection)direction;

- (UIImage *)imageTintedWithColor:(UIColor *)color;
- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;

/*! 模糊图片 */
- (UIImage*)blurredImage:(CGFloat)blurAmount;

/*! 图片应用alpha */
- (UIImage *)imageByApplyingAlpha:(float)alpha;

/*! 修复UIImagePickerController采集后是图片被旋转90度问题 */
- (UIImage *)fixOrientation;

@end
