//
//  LSLQuickLoginButton.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/2.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLQuickLoginButton.h"

@implementation LSLQuickLoginButton

- (void)awakeFromNib
{
    // 设置标题的现实位置
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局图片的位置
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 布局标题的位置
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.height = self.height - self.imageView.height;
    self.titleLabel.width = self.width;
}

@end
