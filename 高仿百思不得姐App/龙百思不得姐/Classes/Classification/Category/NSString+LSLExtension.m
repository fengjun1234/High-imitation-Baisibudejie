//
//  NSString+LSLExtension.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/8.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "NSString+LSLExtension.h"

@implementation NSString (LSLExtension)

// 判断一个路径是否为文件夹/文件
//[[[NSFileManager defaultManager] attributesOfItemAtPath:self error:nil].fileType isEqualToString:NSFileTypeDirectory];

/**
 *  计算文件大小
 */
- (NSInteger)fileSize
{
    // 文件管理者
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 是否为文件
    BOOL isDirectory = NO;
    // 路径是否存在
    BOOL isExists = [manager fileExistsAtPath:self isDirectory:&isDirectory];
    
    // 路径不存在，直接返回0
    if (!isExists) return 0;
    
    if (isDirectory) {  // 文件夹
        // 计算文件大小，保存总数
        NSInteger totalFileSize = 0;
        
        // 获取文件夹中或有内容，根据文件路径生成一个迭代器
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:self];
        
        // 计算所有文件大小
        for (NSString *subPath in enumerator) {
            // 获取全路径
            NSString *fullFilePath = [self stringByAppendingPathComponent:subPath];
            
            // 累计文件大小
            totalFileSize += [manager attributesOfItemAtPath:fullFilePath error:nil].fileSize;
        }
        return totalFileSize;
    }else{  // 文件
        return  [manager attributesOfItemAtPath:self error:nil].fileSize;
    }
}
@end
