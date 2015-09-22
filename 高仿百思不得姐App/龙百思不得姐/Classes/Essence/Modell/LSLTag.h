//
//  LSLTag.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/6.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSLTag : NSObject
/** 是否含有子标签 */
@property(nonatomic,assign)NSInteger is_sub;
/** 此标签的id */
@property(nonatomic,copy)NSString *theme_id;
/** 标签名称 */
@property(nonatomic,copy)NSString *theme_name;
/** 此标签的订阅量 */
@property(nonatomic,assign)NSInteger sub_number;
/** 是否是默认的推荐标签 */
@property(nonatomic,assign)NSInteger is_default;
/** 推荐标签的图片url地址 */
@property(nonatomic,copy)NSString *image_list;
@end
