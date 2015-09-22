//
//  UIView+GetViewFrame.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/2.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "UIView+GetViewFrame.h"

@implementation UIView (GetViewFrame)

/** 从xib中创建view */
+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

/**
 *  x值
 */
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return  self.frame.origin.x;
}

/**
 *  y值
 */
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return  self.frame.origin.y;
}

/**
 *  width值
 */
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return  self.frame.size.width;
}

/**
 *  height值
 */
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return  self.frame.size.height;
}

/**
 *  centerX值
 */
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return  self.center.x;
}

/**
 *  centerY值
 */
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return  self.center.y;
}

/**
 *  size值
 */
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    
}

- (CGSize)size
{
    return self.frame.size;
}
@end
