//
//  LSLCategoryCell.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/8.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  LSLCategory;

@interface LSLCategoryCell : UITableViewCell
/** 左边数据模型 */
@property(nonatomic,strong)LSLCategory *category;
@end
