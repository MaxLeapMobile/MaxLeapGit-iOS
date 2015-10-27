//
//  UIView + CustomBorder.h
//  YouTubeMusic
//
//  Created by Eric on 11/1/13.
//  Copyright (c) 2013 Eric_Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ExcludePoint) {
    ExcludeStartPoint = 1 << 0,
    ExcludeEndPoint = 1 << 1,
    ExcludeAllPoint = ~0UL
};


@interface UIView (CustomBorder)

- (void)addTopBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth;
- (void)addLeftBorderWithColor: (UIColor *) color width:(CGFloat) borderWidth;
- (void)addBottomBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth;
- (void)addRightBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth;

- (void)removeTopBorder;
- (void)removeLeftBorder;
- (void)removeBottomBorder;
- (void)removeRightBorder;

- (void)addTopBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge;
- (void)addLeftBorderWithColor: (UIColor *) color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge;
- (void)addBottomBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge;
- (void)addRightBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge;

@end
