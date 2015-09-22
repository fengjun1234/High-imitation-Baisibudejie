//
//  UIImageView+LSLExtension.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/6.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "UIImageView+LSLExtension.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+LSLExtension.h"

@implementation UIImageView (LSLExtension)
/**
 * 设置头像
 */
- (void)setHeader:(NSString *)url
{
    // 设置头像的形状
    [self setCircleHeader:url];
}

/**
 *  矩形头像
 */
- (void)setRectHeader:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

/**
 *  圆形头像
 */
- (void)setCircleHeader:(NSString *)url
{
    // 推荐标签的图片[UIImage imageNamed:@"defaultUserIcon"]
    // 设置为圆角占位图片
    UIImage *placeholderImage = [UIImage circleImageNamed:@"defaultUserIcon"];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 如果没有图片则显示展示占位图片
        if (image == nil) return ;
        
        // 设置头像为圆角
        self.image = [image circleImage];
    }];
}
@end
