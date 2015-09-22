//
//  LSLCommentCell.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/18.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSLComment;

@interface LSLCommentCell : UITableViewCell
/** 评论数据模型 */
@property(nonatomic,strong)LSLComment *comment;
@end
