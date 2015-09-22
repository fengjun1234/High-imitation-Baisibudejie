//
//  LSLUser.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/8.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSLUser : NSObject
/** 用户名称 */
@property(nonatomic,copy)NSString *screen_name;
/** 关注数量 */
@property(nonatomic,assign)NSInteger fans_count;
/** 头像 */
@property(nonatomic,copy)NSString *header;
@end


