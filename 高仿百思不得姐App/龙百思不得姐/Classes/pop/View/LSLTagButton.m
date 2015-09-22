//
//  LSLTagButton.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/12.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLTagButton.h"

@implementation LSLTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = LSLTagBtnBGColor;
        self.titleLabel.font  = [UIFont systemFontOfSize:15];
    }
    return self;
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 自动计算
    [self sizeToFit];
    
    // 微调
    self.width += 3 * LSLCommonSmallMargin;
    self.height = LSLTagHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = LSLCommonSmallMargin;
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + LSLCommonSmallMargin;
}

@end
