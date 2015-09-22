//
//  LSLMeController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLMeController.h"
#import "LSLSettingController.h"
#import "LSLMeCell.h"
#import "LSLMeFooterView.h"

@interface LSLMeController ()

@end

/** cellId */
static NSString * const LSLMeCellID = @"me";
@implementation LSLMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置nav属性
    [self setupNav];
    
    // 设置tableView
    [self setupTable];
    
}

/**
 *  设置tableView
 */
- (void)setupTable
{
    // 注册cell
    [self.tableView registerClass:[LSLMeCell class] forCellReuseIdentifier:LSLMeCellID];
    
    // 设置间距
    self.tableView.contentInset = UIEdgeInsetsMake(LSLCommonMargin - 35, 0, 0, 0);
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = LSLCommonMargin;
    
    // 底部视图
    self.tableView.tableFooterView = [[LSLMeFooterView alloc] init];
    
//    self.tableView.contentSize = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>)
}

/**
 *  设置nav属
 */
- (void)setupNav
{
    // 设置标题和背景颜色
    self.navigationItem.title = @"我的";
    
    self.view.backgroundColor = LSLCommenBGColor;
    
    // 设置右边的按钮
    // 月亮按钮
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highlightedImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    
    // 设置按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highlightedImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
}


// moonClick按钮的点击事件
- (void)moonClick
{
    LSLFUNC;
}

// moonClick按钮的点击事件
- (void)settingClick
{
    LSLSettingController *settingVC = [[LSLSettingController alloc] initWithStyle:UITableViewStyleGrouped];
    
    settingVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

#pragma mark - 设置数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSLMeCell *cell = [tableView dequeueReusableCellWithIdentifier:LSLMeCellID];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
    }else{
        cell.textLabel.text = @"离线下载";
    }
    return cell;
}



@end
