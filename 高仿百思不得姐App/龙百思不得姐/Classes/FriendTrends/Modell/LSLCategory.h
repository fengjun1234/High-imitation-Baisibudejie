//
//  LSLCategory.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/8.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  LSLUser;

@interface LSLCategory : NSObject
/** id */
@property(nonatomic,assign)NSInteger categoryID;
/** 名称 */
@property(nonatomic,copy)NSString *name;
/** 用户数 */
@property(nonatomic,assign)NSInteger count;


/** 用户信息数据模型 */
@property(nonatomic,strong)NSMutableArray *users;
/** 总个数 */
@property(nonatomic,assign)NSInteger total;
/** 当前页码 */
@property(nonatomic,assign)NSInteger currentPage;
@end
