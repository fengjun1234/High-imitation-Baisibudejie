
//
//  LSLTopicVideoView.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/17.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLTopicVideoView.h"
#import "LSLTopic.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LSLTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;

@end

@implementation LSLTopicVideoView

- (void)awakeFromNib
{
    // 清楚自动伸缩
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(LSLTopic *)topic
{
    _topic = topic;
    
    // 设置显示数据
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.cdn_img]];
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放",self.topic.playcount];
    
    NSInteger minute = self.topic.videotime / 60;
    CGFloat second = self.topic.videotime % 60;
    // %02zd表示保留两位数，且不足时用0补齐
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}




@end
