//
//  LSLTopic.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/14.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSLComment;

typedef enum {
    /** 帖子的类型,1为All全部 */
    LSLTopicTypeAll     = 1,
    
    /** 帖子的类型,10为Picture图片*/
    LSLTopicTypePicture = 10,
    
    /** 帖子的类型,29为Word段子*/
    LSLTopicTypeWord    = 29,
    
    /** 帖子的类型,31为Audio音频*/
    LSLTopicTypeAudio   = 31,
    
    /** 帖子的类型,41为Video视频 */
    LSLTopicTypeVideo   = 41
}LSLTopicType;

@interface LSLTopic : NSObject
/** 用户名称 */
@property(nonatomic,copy)NSString *name;
/** 发帖人的昵称 */
@property(nonatomic,copy)NSString *screen_name;
/** 头像的图片url地址 */
@property(nonatomic,copy)NSString *profile_image;
/** 系统审核通过后创建帖子的时间 */
@property(nonatomic,copy)NSString *created_at;

/** 帖子id */
@property(nonatomic,copy)NSString *ID; // id

/** 帖子的内容 */
@property(nonatomic,copy)NSString *text;
/** 帖子的标签备注 */
@property(nonatomic,copy)NSString *tag;
/** 帖子的收藏量 */
@property(nonatomic,copy)NSString *favourite;
/** 最热评论 */
@property(nonatomic,strong)LSLComment *hotComent;

/** 如果为音频，则为音频的播放地址 */
@property(nonatomic,copy)NSString *voiceuri;
/** 视频加载时候的静态显示的图片地址 */
@property(nonatomic,copy)NSString *cdn_img;
/** 显示在页面中的视频图片的url,缩略图 */
@property(nonatomic,copy)NSString *image0;
/** 显示在页面中的视频图片的url，大图 */
@property(nonatomic,copy)NSString *image1;
/** 显示在页面中的视频图片的url，中图 */
@property(nonatomic,copy)NSString *image2;

/** 收藏量 */
@property(nonatomic,assign)NSInteger love;
/** 顶 */
@property(nonatomic,assign)NSInteger ding;
/** 踩的人数 */
@property(nonatomic,assign)NSInteger cai;
/** 转发的数量 */
@property(nonatomic,assign)NSInteger repost;
/** 帖子的被评论数量 */
@property(nonatomic,assign)NSInteger comment;

/** 帖子的类型，1为全部 10为图片 29为段子 31为音频 41为视频 */
@property(nonatomic,assign)LSLTopicType type;
/** 图片或视频等其他的内容的高度 */
@property(nonatomic,assign)CGFloat height;
/** 图片或视频等其他的内容的宽度 */
@property(nonatomic,assign)CGFloat width;
/** 是否是gif图 */
@property(nonatomic,assign)BOOL is_gif;

/** 视频播放次数 */
@property(nonatomic,assign)NSInteger playcount;
/** 如果含有视频则该参数为视频的长度 */
@property(nonatomic,assign)NSInteger videotime;
/** 如果为音频类帖子，则返回值为音频的时长 */
@property(nonatomic,assign)NSInteger voicetime;
/** 如果为音频则为音频的时长 */
@property(nonatomic,assign)NSInteger voicelength;
/** 踩的数量 */
@property(nonatomic,copy)NSString *hate;



/******* 额外扩展的一些属性  *************/
/** cell的高度 */
@property(nonatomic,assign)CGFloat cellHeight;
/** 图片的frame */
@property(nonatomic,assign)CGRect contentFrame;
/** 是否大图片 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;
@end
