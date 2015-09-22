//
//  LSLTopic.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/14.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLTopic.h"
#import "LSLComment.h"
#import "LSLCommentUser.h"

@implementation LSLTopic
/**
 *  处理帖子发表时间
 */
- (NSString *)created_at
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_created_at];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [create intervalToNow];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _created_at;
    }
}

#pragma mark - 计算cell的实际高度
- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        // 1.cell的高度
        _cellHeight = LSLTopicContentY;
        
        // 2.计算帖子内容的高度
        CGFloat textW = LSLScreenWidth - 2 * LSLCommonMargin;
        CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        _cellHeight += textH + LSLCommonMargin;
        
        // 3.中间内容的高度
        if (self.type != LSLTopicTypeWord) { // 不是文字的情况下
            //内容的宽度和高度
            CGFloat contentW = textW;
            // 图片的高度 * 内容的宽度 / 图片的宽度
            CGFloat contentH = contentW * self.height / self.width;
            
            // 计算图片的Frame,当内容高度大于屏幕高度时，设置内容高度为200
            if (contentH > LSLScreenHeight) {
                contentH = 200;
                _bigPicture = YES;
            }
            CGFloat contentX = LSLCommonMargin;
            CGFloat contentY = _cellHeight;
            _contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
            
            _cellHeight += contentH + LSLCommonMargin;
        }
        
        // 设置最热评论
        if (self.hotComent) {
            // 计算最热评论内容的高
            NSString *content = [NSString stringWithFormat:@"%@：%@",self.hotComent.user.username,self.hotComent.content];
            
            CGFloat commentTextH = [content boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            
            _cellHeight += LSLCellHotCommentTitleHeight + commentTextH + LSLCommonMargin;
        }
        
        
        // 4.工具条的高度+cell之间的间距
        _cellHeight += LSLToolBarHeight + LSLCommonMargin;
    }

    return _cellHeight;
}









@end
