//
//  LSLSettingController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLSettingController.h"
#import "LSLClearCacheCell.h"

@interface LSLSettingController ()

@end
/** 清空缓存cell */
static NSString * const LSLClearCacheCellID = @"cacheCell";
/** 其它cell */
static NSString * const LSLOtherCellID = @"otherCell";

@implementation LSLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏属性和背景颜色
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = LSLCommenBGColor;
    
    // 设置内边距
    self.tableView.contentInset = UIEdgeInsetsMake(LSLCommonMargin - 35, 0, 0, 0);
    
    // 注册cell
    [self.tableView registerClass:[LSLClearCacheCell class] forCellReuseIdentifier:LSLClearCacheCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LSLOtherCellID];
}

#pragma mark - 设置数据源 <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        LSLClearCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:LSLClearCacheCellID];
        [cell updateCache];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LSLOtherCellID];
        return cell;
    }
}

#pragma mark - 代理方法 <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 当选择清空缓存cell时，取消选择
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // 清空缓存
        LSLClearCacheCell *cell = (LSLClearCacheCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell clearCaches];
        
        // 清空后禁止用户继续点击
        cell.userInteractionEnabled = NO;
    }
}

@end
