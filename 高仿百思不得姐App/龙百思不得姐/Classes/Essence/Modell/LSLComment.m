//
//  LSLComment.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/17.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLComment.h"

@implementation LSLComment

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        CGFloat contentW = LSLScreenWidth - (55 + 50);
        CGFloat contentH = [_content boundingRectWithSize:CGSizeMake(contentW, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height;
        
        _cellHeight = 45 + contentH + LSLCommonMargin;
    }

    return _cellHeight;
}

@end
