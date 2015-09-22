//
//  UITextField+LSLExtension.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/12.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "UITextField+LSLExtension.h"

/** 占位文字颜色 */
static NSString * const LSLPlaceholderColorKey = @"placeholderLabel.textColor";

@implementation UITextField (LSLExtension)

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // 保证有占位文字
    BOOL isChanged = NO;
    if (self.placeholder == nil) {
        self.placeholder = @" ";
        isChanged  = YES;
    }
    
    // 设置颜色
    [self setValue:placeholderColor forKeyPath:LSLPlaceholderColorKey];
    
    // 恢复原状
    if (isChanged) self.placeholder = nil;
}

- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:LSLPlaceholderColorKey];
}
@end
