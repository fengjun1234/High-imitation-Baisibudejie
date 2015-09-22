//
//  LSLCommentCell.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/18.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLCommentCell.h"
#import "LSLComment.h"
#import "LSLCommentUser.h"

@interface LSLCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UILabel *dingLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

@end

@implementation LSLCommentCell

- (void)awakeFromNib
{
    // 设置cell的背景图片
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
    // 选中时不变色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setComment:(LSLComment *)comment
{
    _comment = comment;
    
    // 是否显示语音
    if (comment.voiceuri.length) {
        self.voiceBtn.hidden = NO;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
    }else{
        self.voiceBtn.hidden = YES;
    }

    // 设置显示数据
    [self.iconImageView setHeader:comment.user.profile_image];
    self.userNameLabel.text = comment.user.username;
    self.commentContentLabel.text = comment.content;
    self.dingLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    if ([comment.user.sex isEqualToString:@"m"]) {
        self.sexImageView.image = [UIImage imageNamed:@"Profile_manIcon"];
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"Profile_womanIcon"];
    }
}

@end
