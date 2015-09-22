//
//  LSLTagCell.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/6.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLTagCell.h"
#import "LSLTag.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LSLTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListV;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation LSLTagCell

// 设置头像圆角
//- (void)awakeFromNib
//{
//    self.imageListV.layer.cornerRadius = self.imageListV.frame.size.width * 0.5;
//    self.imageListV.layer.masksToBounds = YES;
//}

// 重写setFrame方法，设置分割线
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

// 显示数据
- (void)setModalTag:(LSLTag *)modalTag
{
    _modalTag = modalTag;
    
    // 推荐标签的图片
    [self.imageListV setHeader:modalTag.image_list];
    
    // 标签名称
    self.themeNameLabel.text = modalTag.theme_name;

    // 此标签的订阅量
    if (modalTag.sub_number >= 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅",modalTag.sub_number / 10000.0];
    }else{
        self.subNumberLabel.text = [NSString stringWithFormat:@"%zd人订阅",modalTag.sub_number];
    }
}

@end
