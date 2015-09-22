//
//  NSDate+LSLExtension.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/14.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LSLExtension)
/**
 *  返回两个NSDate对象相比的时间差
 */
- (NSDateComponents *)intervalToDate:(NSDate *)date;

/**
 *  某个NSDate对象调用此方法，返回和当前时间相比的差值
 */
- (NSDateComponents *)intervalToNow;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;
@end
