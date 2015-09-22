//
//  UIBarButtonItem+LSLCategory.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LSLCategory)
+ (instancetype)itemWithImage:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title image:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;
@end
