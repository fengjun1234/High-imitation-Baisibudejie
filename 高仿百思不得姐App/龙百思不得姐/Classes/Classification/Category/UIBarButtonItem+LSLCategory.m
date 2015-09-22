//
//  UIBarButtonItem+LSLCategory.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "UIBarButtonItem+LSLCategory.h"

@implementation UIBarButtonItem (LSLCategory)

/**
 *  统一设置普通导航栏的按钮样式
 *
 *  @param image            按钮normal状态下的图片
 *  @param highlightedImage 按钮高亮状态下的图片
 *  @param target           按钮的调用对象
 *  @param action           方法
 */
+ (instancetype)itemWithImage:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    // 添加事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:btn];
}

/**
 *  统一设置返回按钮的样式
 *
 *  @param title            按钮标题
 *  @param image            按钮normal状态下的图片
 *  @param highlightedImage 按钮高亮状态下的图片
 *  @param target           按钮的调用对象
 *  @param action           方法
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title image:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置按钮文字
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    // 设置按钮图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    // 设置按钮的位置
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    // 返回按钮的点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:btn];
}

@end
