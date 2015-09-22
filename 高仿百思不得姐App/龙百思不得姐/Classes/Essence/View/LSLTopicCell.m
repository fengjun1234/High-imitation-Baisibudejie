//
//  LSLTopicCell.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/14.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLTopicCell.h"
#import "LSLTopic.h"
#import "LSLTopicPictureView.h"
#import "LSLTopicAudioView.h"
#import "LSLTopicVideoView.h"
#import "LSLComment.h"
#import "LSLCommentUser.h"

@interface LSLTopicCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 帖子图片 */
@property(nonatomic,strong)LSLTopicPictureView *pictureView;
/** 帖子声音 */
@property(nonatomic,strong)LSLTopicAudioView *audioView;
/** 帖子视频 */
@property(nonatomic,strong)LSLTopicVideoView *videoView;
/** 最热评论viewe */
@property (weak, nonatomic) IBOutlet UIView *hotCommentView;
/** 最热评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *hotCommentLabel;
@end

@implementation LSLTopicCell

#pragma mark - 懒加载
- (LSLTopicPictureView *)pictureView
{
    if (!_pictureView) {
        LSLTopicPictureView *pictureView = [LSLTopicPictureView viewFromXib];
        [self addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (LSLTopicAudioView *)audioView
{
    if (!_audioView) {
        LSLTopicAudioView *audioView = [LSLTopicAudioView viewFromXib];
        [self addSubview:audioView];
        _audioView = audioView;
    }
    return _audioView;
}

-  (LSLTopicVideoView *)videoView
{
    if (!_videoView) {
        LSLTopicVideoView *videoView = [LSLTopicVideoView viewFromXib];
        [self addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib {
    // 设置cell的背景图片
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
    // 选中一行后，不显示选中颜色的方法 不要将tableview的allowsSelection设置成NO，那样的话可能导致tableview不能响应点击动作。
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

// 重写frame方法，重设cell的高和y
- (void)setFrame:(CGRect)frame
{
    // 重新设定cell的高和y
    frame.size.height -= LSLCommonMargin;
    frame.origin.y += LSLCommonMargin;

    [super setFrame:frame];
}

// 重写topoic模型数据属性
- (void)setTopic:(LSLTopic *)topic
{
    _topic = topic;
    
    // 设置显示数据
    [self.profileImageView setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.createAtLabel.text = topic.created_at;
    self.text_label.text = topic.text;
    
    // 工具条的数目
    [self setButtonTitle:self.dingButton number:topic.ding placholder:@"顶"];
    [self setButtonTitle:self.caiButton number:topic.cai placholder:@"踩"];
    [self setButtonTitle:self.shareButton number:topic.repost placholder:@"分享"];
    [self setButtonTitle:self.commentButton number:topic.comment placholder:@"评价"];
    
    // 创建帖子内容
    if (topic.type == LSLTopicTypePicture) {    // 图片
        self.audioView.hidden = YES;
        self.videoView.hidden = YES;
        
        self.pictureView.hidden = NO;
        self.pictureView.frame = topic.contentFrame;
        self.pictureView.topic = topic;
        
    }else if (topic.type == LSLTopicTypeAudio){ // 声音
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        
        self.audioView.hidden = NO;
        self.audioView.frame = topic.contentFrame;
        self.audioView.topic = topic;
        
    }else if (topic.type == LSLTopicTypeVideo){ // 视频
        self.pictureView.hidden = YES;
        self.audioView.hidden = YES;
        
        self.videoView.hidden = NO;
        self.videoView.frame = topic.contentFrame;
        self.videoView.topic = topic;
        
    }else if (topic.type == LSLTopicTypeWord){  // 段子
        self.pictureView.hidden = YES;
        self.audioView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    // 最热评论
    if (self.topic.hotComent) {
        self.hotCommentView.hidden = NO;
        NSString *userName = self.topic.hotComent.user.username;
        NSString *content = self.topic.hotComent.content;
        self.hotCommentLabel.text = [NSString stringWithFormat:@"%@：%@",userName,content];
    }else{
        self.hotCommentView.hidden = YES;
    }
}

// 设置按钮的标题
- (void)setButtonTitle:(UIButton *)button number:(NSInteger)number placholder:(NSString *)placholder
{
    if (number > 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万",number / 10000.0] forState:UIControlStateNormal];
    }else if(number > 0){
        [button setTitle:[NSString stringWithFormat:@"%zd",number] forState:UIControlStateNormal];
    }else{
        [button setTitle:placholder forState:UIControlStateNormal];
    }
}

// 点击更多按钮
- (IBAction)moreClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        LSLLog(@"收藏");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        LSLLog(@"举报");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        LSLLog(@"取消");
    }]];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
