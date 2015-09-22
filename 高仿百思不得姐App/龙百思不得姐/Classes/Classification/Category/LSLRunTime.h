//
//  LSLRunTime.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/4.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSLRunTime : NSObject
/**
 *  利用运行时，遍历某个类所有的成员变量并打印
 *
 *  @param objc 等待访问的对象
 */
+ (void)copyIvarListWithClassName:(id)objc;
@end
