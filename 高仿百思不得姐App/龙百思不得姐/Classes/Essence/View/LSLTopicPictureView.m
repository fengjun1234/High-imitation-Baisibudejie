//
//  LSLTopicPictureView.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/16.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLTopicPictureView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LSLTopic.h"
#import <DACircularProgress/DALabeledCircularProgressView.h>
#import "LSLSeeBigPictureViewController.h"

@interface LSLTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureBtn;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;


@end

@implementation LSLTopicPictureView

- (void)awakeFromNib
{
    // 清楚自动伸缩属性
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
    
    // 首先设置图片为可交互的，再给图片添加点击手势
    self.pictureImageView.userInteractionEnabled = YES;
    [self.pictureImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)]];
}

// 点击图片时弹出查看大图界面
- (void)imageClick
{
    // 还未加载完图片，不予许点击查看大图片
    if (self.pictureImageView.image == nil) return;
    
    LSLSeeBigPictureViewController *bigImageVC = [[LSLSeeBigPictureViewController alloc] init];
    bigImageVC.topic = self.topic;
    [self.window.rootViewController presentViewController:bigImageVC animated:YES completion:nil];
}

- (void)setTopic:(LSLTopic *)topic
{
    _topic = topic;
    
    LSLWeakSelf;
    // 内容图片
    [weakSelf.pictureImageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
        weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.1f%%",100.0 * weakSelf.progressView.progress];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.progressView.hidden = YES;
    }];
    
    // 是否为gif图片
    self.gifImageView.hidden = !topic.is_gif;
    // 也可以通过扩展名判断,返回lowercaseString小写,uppercaseString大写
    
    // 是否需要显示大图按钮
    self.seeBigPictureBtn.hidden = !topic.isBigPicture;
    if (topic.isBigPicture) {
        self.pictureImageView.contentMode = UIViewContentModeTop;
        self.pictureImageView.clipsToBounds = YES;
    }else{
        self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
        self.pictureImageView.clipsToBounds = NO;
    }
}



- (IBAction)seeBigPictureBtnClick:(id)sender {
    [self imageClick];
}

@end
