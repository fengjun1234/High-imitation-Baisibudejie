//
//  LSLSquareButton.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/7.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLSquareButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "LSLSquare.h"

@implementation LSLSquareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
        
        // 设置文字属性
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图标位置
    CGFloat imgW = self.width * 0.55;
    CGFloat imgH = imgW;
    CGFloat imgX = (self.width - imgW) * 0.5;
    CGFloat imgY = LSLCommonMargin * 0.5;
    
    self.imageView.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    // 设置标题位置
    CGFloat labelX = 0;
    CGFloat labelY = CGRectGetMaxY(self.imageView.frame);
    CGFloat labelW = self.width;
    CGFloat labelH = self.height - labelY;
    
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

/**
 *  设置显示数据
 */
- (void)setSquare:(LSLSquare *)square
{
    _square = square;
    
    // 标题
    [self setTitle:square.name forState:UIControlStateNormal];
    
    // 图标
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}
@end
