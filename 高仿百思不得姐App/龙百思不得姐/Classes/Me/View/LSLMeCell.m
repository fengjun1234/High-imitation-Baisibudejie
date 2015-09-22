//
//  LSLMeCell.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/7.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLMeCell.h"

@implementation LSLMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置右边箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // 设置标题的样式
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
        // 设置背景
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片尺寸
    self.imageView.y = LSLCommonMargin * 0.5;
    self.imageView.height = self.contentView.height - LSLCommonMargin;
    self.imageView.width = self.imageView.height;
    
    // 设置cell图片和标题的间距
    if (self.imageView.image == nil) return;
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + LSLCommonMargin;
}
@end
