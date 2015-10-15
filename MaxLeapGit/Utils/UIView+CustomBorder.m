//
//  UIView + CustomBorder.m
//  YouTubeMusic
//
//  Created by Eric on 11/1/13.
//  Copyright (c) 2013 Eric_Hu. All rights reserved.
//

#import "UIView+CustomBorder.h"

typedef NS_ENUM(NSInteger, EdgeType) {
    TopBorder = 10000,
    LeftBorder = 20000,
    BottomBorder = 30000,
    RightBorder = 40000
};


@implementation UIView (CustomBorder)


- (void)removeTopBorder {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (subView.tag == TopBorder) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)removeLeftBorder {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (subView.tag == LeftBorder) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)removeBottomBorder {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (subView.tag == BottomBorder) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)removeRightBorder {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (subView.tag == RightBorder) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)addTopBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth {
    [self addTopBorderWithColor:color width:borderWidth excludePoint:0 edgeType:0];
}


- (void)addLeftBorderWithColor: (UIColor *) color width:(CGFloat) borderWidth {
    [self addLeftBorderWithColor:color width:borderWidth excludePoint:0 edgeType:0];
}


- (void)addBottomBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth {
    [self addBottomBorderWithColor:color width:borderWidth excludePoint:0 edgeType:0];
}


- (void)addRightBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth {
    [self addRightBorderWithColor:color width:borderWidth excludePoint:0 edgeType:0];
}


- (void)addTopBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge {
    [self removeTopBorder];
    
    UIView *border = [UIView autoLayoutView];
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = TopBorder;

    [self addSubview:border];
    
    CGFloat startPoint = 0.0f;
    CGFloat endPoint = 0.0f;
    if (edge & ExcludeStartPoint) {
        startPoint += point;
    }
    
    if (edge & ExcludeEndPoint) {
        endPoint += point;
    }
    
    [border pinToSuperviewEdges:JRTViewPinLeftEdge inset:startPoint];
    [border pinToSuperviewEdges:JRTViewPinTopEdge inset:0.0];
    [border pinToSuperviewEdges:JRTViewPinRightEdge inset:endPoint];
    [border constrainToHeight:borderWidth];
}


- (void)addLeftBorderWithColor: (UIColor *) color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge {
    [self removeLeftBorder];
    
    UIView *border = [UIView autoLayoutView];
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = LeftBorder;
    [self addSubview:border];
    
    CGFloat startPoint = 0.0f;
    CGFloat endPoint = 0.0f;
    if (edge & ExcludeStartPoint) {
        startPoint += point;
    }
    
    if (edge & ExcludeEndPoint) {
        endPoint += point;
    }
    
    [border pinToSuperviewEdges:JRTViewPinTopEdge inset:startPoint];
    [border pinToSuperviewEdges:JRTViewPinLeftEdge inset:0.0];
    [border pinToSuperviewEdges:JRTViewPinBottomEdge inset:endPoint];
    [border constrainToWidth:borderWidth];
}


- (void)addBottomBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge {
    [self removeBottomBorder];
    
    UIView *border = [UIView autoLayoutView];
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = BottomBorder;
    [self addSubview:border];
    
    CGFloat startPoint = 0.0f;
    CGFloat endPoint = 0.0f;
    if (edge & ExcludeStartPoint) {
        startPoint += point;
    }
    
    if (edge & ExcludeEndPoint) {
        endPoint += point;
    }
    
    [border pinToSuperviewEdges:JRTViewPinLeftEdge inset:startPoint];
    [border pinToSuperviewEdges:JRTViewPinBottomEdge inset:0.0];
    [border pinToSuperviewEdges:JRTViewPinRightEdge inset:endPoint];
    [border constrainToHeight:borderWidth];
}



- (void)addRightBorderWithColor:(UIColor *)color width:(CGFloat) borderWidth excludePoint:(CGFloat)point edgeType:(ExcludePoint)edge {
    [self removeRightBorder];
    
    UIView *border = [UIView autoLayoutView];
    border.userInteractionEnabled = NO;
    border.backgroundColor = color;
    border.tag = RightBorder;
    [self addSubview:border];
    
    CGFloat startPoint = 0.0f;
    CGFloat endPoint = 0.0f;
    if (edge & ExcludeStartPoint) {
        startPoint += point;
    }
    
    if (edge & ExcludeEndPoint) {
        endPoint += point;
    }
    
    [border pinToSuperviewEdges:JRTViewPinTopEdge inset:startPoint];
    [border pinToSuperviewEdges:JRTViewPinRightEdge inset:0.0];
    [border pinToSuperviewEdges:JRTViewPinBottomEdge inset:endPoint];
    [border constrainToWidth:borderWidth];
}


@end
