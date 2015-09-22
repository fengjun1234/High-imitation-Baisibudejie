//
//  LSLPublishButton.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/15.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLPublishButton.h"

@implementation LSLPublishButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.imageView.backgroundColor = [UIColor greenColor];
//        self.titleLabel.backgroundColor = [UIColor blueColor];
        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片位置
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 设置标题位置
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
