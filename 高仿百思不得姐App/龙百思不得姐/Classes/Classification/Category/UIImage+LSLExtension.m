//
//  UIImage+LSLExtension.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/6.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "UIImage+LSLExtension.h"

@implementation UIImage (LSLExtension)
/* 返回圆形头像 */
- (instancetype)circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 获取图形上下文
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    // 创建一个矩形
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 添加一个圆
    CGContextAddEllipseInRect(cxt, rect);
    
    // 裁剪成一个圆
    CGContextClip(cxt);
    
    // 往圆上画图片
    [self drawInRect:rect];
    
    // 获取图形上下文图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)circleImageNamed:(NSString *)name
{
    return [[UIImage imageNamed:name] circleImage];
}

@end
