//
//  LSLUserCell.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/8.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLUserCell.h"
#import "LSLUser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LSLUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation LSLUserCell

- (void)awakeFromNib {
}

// 重写setFrame方法，设置分割线
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)setRecommendUser:(LSLUser *)recommendUser
{
    _recommendUser = recommendUser;
    
    // 设置显示数据
    self.screenNameLabel.text = recommendUser.screen_name;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注",recommendUser.fans_count];
    
    // 加载头像
    [self.iconImageView setHeader:recommendUser.header];
}

@end
