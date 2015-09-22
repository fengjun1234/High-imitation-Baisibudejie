//
//  UIView+GetViewFrame.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/2.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GetViewFrame)
@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;
@property(nonatomic,assign)CGSize size;

/** 从xib中创建view */
+ (instancetype)viewFromXib;
@end
