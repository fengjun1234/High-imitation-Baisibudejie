//
//  LSLClearCacheCell.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/8.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLClearCacheCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

// SDW控件缓存路径
#define LSLCacheFile [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask , YES) firstObject] stringByAppendingPathComponent:@"default"]

@implementation LSLClearCacheCell

static NSString * const LSLClearCacheInfo = @"清空缓存";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置数据
        self.textLabel.text = [NSString stringWithFormat:@"正在计算缓存量......"];
        
        // 计算缓存过程中，禁止用户交互
        self.userInteractionEnabled = NO;
        
        // 创建指示器
        UIActivityIndicatorView *activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityV startAnimating];
        self.accessoryView = activityV;
        
        // 在子线程中，计算缓存
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 计算文件大小，保存总数
            NSInteger totalFileSize = [LSLCacheFile fileSize];
            
            // 组装缓存信息
            NSString *sizeText = nil;
            CGFloat unit = 1000.0;
            
            if (totalFileSize >= unit * unit * unit) { // 大于等于1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB",totalFileSize / unit / unit / unit];
            }else if (totalFileSize > unit * unit) { // 大于等于1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB",totalFileSize / unit / unit];
            }else if (totalFileSize > unit) { // 大于等于1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB",totalFileSize / unit];
            }else{
                sizeText = [NSString stringWithFormat:@"%zdB",totalFileSize];
            }
            
            NSString *text = [NSString stringWithFormat:@"%@(%@)",LSLClearCacheInfo,sizeText];
            
            // 模拟计算延迟
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            
                // 在主线程中，更新界面
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // 显示缓存量
                    self.textLabel.text = text;
                    
                    // 去除右边指示器
                    self.accessoryView = nil;
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    // 允许点击
                    self.userInteractionEnabled = YES;
                });
            });
//        });
    }
    return self;
}

/**
 *  当循环引用cell时，显示当前指示器
 */
- (void)updateCache
{
    if (self.accessoryView == nil) return;
    
    UIActivityIndicatorView *act = (UIActivityIndicatorView *)self.accessoryView;
    [act startAnimating];
}

/**
 *  清空缓存
 */
- (void)clearCaches
{
    // 弹出对话框
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在%@,请稍等......",LSLClearCacheInfo] maskType:SVProgressHUDMaskTypeBlack];
    
    // 在子线程中清空缓存
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        // 清空缓存
        [[NSFileManager defaultManager] removeItemAtPath:LSLCacheFile error:nil];
        
        // 模拟延迟
//        [NSThread sleepForTimeInterval:2.0];
        
        // 在主线程中更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功",LSLClearCacheInfo]];
            
            self.textLabel.text = LSLClearCacheInfo;
        }];
    }];
}


@end
