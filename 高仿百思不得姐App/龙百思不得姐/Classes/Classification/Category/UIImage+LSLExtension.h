//
//  UIImage+LSLExtension.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/6.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LSLExtension)
/* 返回圆形头像 */
- (instancetype)circleImage;
+ (instancetype)circleImageNamed:(NSString *)name;
@end
