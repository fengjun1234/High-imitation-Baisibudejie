//
//  LSLRunTime.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/4.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLRunTime.h"
//#import <objc/runtime.h>
// 或
#import <objc/message.h>

@implementation LSLRunTime

/**
 *  利用运行时，遍历某个类所有的成员变量并打印
 *
 *  @param objc 等待访问的对象
 */
+ (void)copyIvarListWithClassName:(id)objc
{
    /**
     1.什么是运行时（Runtime）?
     * 运行时是苹果提供的纯C语言的开发库（运行时是一种非常牛逼、开发中经常用到的底层技术）
     
     2.运行时的作用？
     * 能获得某个类的所有成员变量
     * 能获得某个类的所有属性
     * 能获得某个类的所有方法
     * 交换方法实现
     * 能动态添加一个成员变量
     * 能动态添加一个属性
     * 能动态添加一个方法
     */
    
    // 成员变量的数量
    unsigned int outCount = 0;
    
    // 获得所有的成员变量
    Ivar *ivars = class_copyIvarList([objc class], &outCount);
    
    // 遍历所有的成员变量
    for (int i = 0; i<outCount; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 获得成员变量的名字
        const char *propertyName = ivar_getName(ivar);
        
        // 获取变量编码类型
        const char *propertyType = ivar_getTypeEncoding(ivar);
        
        // 打印
        NSLog(@"%@:%s--%s",objc, propertyName ,propertyType);
    }
    
    // 如果函数名中包含了copy\new\retain\create等字眼，那么这个函数返回的数据就需要手动释放
    free(ivars);
}
@end
