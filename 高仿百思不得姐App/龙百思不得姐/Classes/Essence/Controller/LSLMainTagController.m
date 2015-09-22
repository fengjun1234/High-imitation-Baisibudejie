//
//  LSLMainTagController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLMainTagController.h"
#import "LSLTagCell.h"
#import "LSLTag.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface LSLMainTagController ()
/* 数据模型 */
@property(nonatomic,strong)NSArray *tags;
/* 请求管理 */
@property(nonatomic,weak)AFHTTPSessionManager *manager;
@end

/* 全局变量,(全局，static只有一块内存空间、const不可变) */
static NSString * const LSLTagCellID = @"tag";

@implementation LSLMainTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.navigationItem.title = @"推荐标签";
    
    // 设置tableview属性
    [self setupTabel];

    // 获取网络数据
    [self setupLoadTags];
}

/**
 *  获取网络数据
 */
- (void)setupLoadTags
{
    // 弹出提示框
    [SVProgressHUD show];
    
    // 请求参数
    NSDictionary *dict = @{
                           @"a":@"tag_recommend",
                           @"action":@"sub",
                           @"c":@"topic"
                           };
    // 弱引用
    LSLWeakSelf;
    
    // 发送请求
    [self.manager GET:LSLRequestURL parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 1.判断是否有响应数据
        if (responseObject == nil) {
            // 弹出提示框
            [SVProgressHUD showErrorWithStatus:@"加载数据失败,请重新加载！"];
            return;
        }
        
        // 2.获取网络数据
        weakSelf.tags = [LSLTag objectArrayWithKeyValuesArray:responseObject];
        
        // 3.刷新表格
        [weakSelf.tableView reloadData];
        
        // 4.关闭提示框
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 如果是取消了任务，就不算请求失败，就直接返回
        if (error.code == NSURLErrorCancelled) return;
        
        if (error.code == NSURLErrorTimedOut) {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据超时，请稍后再试！"];
        } else {
            // 关闭弹框
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
        }
    }];
}

/**
 *  当前窗口销毁时做一些操作
 */
- (void)dealloc
{
    // 1.停止发送请求
    // 方法1：sessionRequest未挂
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 方法2：sessionRequest已挂
//    [self.manager invalidateSessionCancelingTasks:YES];

    // 2.关闭提示框
    [SVProgressHUD dismiss];
}

/**
 *  设置tableview属性
 */
- (void)setupTabel
{
    self.tableView.backgroundColor = LSLCommenBGColor;
    
    // 设置cell行高
    self.tableView.rowHeight = 70;
    
    // 设置分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 通过注册获取cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSLTagCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LSLTagCellID];
}

#pragma mark - 设置数据源 <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSLTagCell *cell = [tableView dequeueReusableCellWithIdentifier:LSLTagCellID];
    
    // 设置数据
    cell.modalTag = self.tags[indexPath.row];
    
    return cell;
}

#pragma mark - 懒加载数据模型tags
- (NSArray *)tags
{
    if (!_tags) {
        _tags = [NSArray array];
    }
    return _tags;
}

#pragma mark - 懒加载数据模型manager
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
@end
