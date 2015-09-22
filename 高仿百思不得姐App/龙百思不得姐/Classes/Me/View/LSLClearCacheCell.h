//
//  LSLClearCacheCell.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/8.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLClearCacheCell : UITableViewCell
/**
 *  清空缓存
 */
- (void)clearCaches;
/**
 *  当循环引用cell时，显示当前指示器
 */
- (void)updateCache;
@end
