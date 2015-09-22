//
//  LSLRecommendViewController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/8.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLRecommendViewController.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "LSLCategory.h"
#import "LSLCategoryCell.h"
#import "LSLUserCell.h"
#import "LSLUser.h"

/** 获取选中行category */
#define LSLCategoryForSelectedRow self.categorys[self.categoryTableView.indexPathForSelectedRow.row]

@interface LSLRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
/** 左边数据模型 */
@property(nonatomic,strong) NSArray *categorys;
/** 页数 */
@property(nonatomic,assign) NSInteger pages;
/** 网络请求 */
@property(nonatomic,weak)AFHTTPSessionManager *manager;
@end

/** 左边数据cell标识 */
static NSString * const LSLCategoryCellID = @"categoryCell";
/** 右边数据cell标识 */
static NSString * const LSLUserCellID = @"userCell";

@implementation LSLRecommendViewController
#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView的属性
    [self setupTableView];
    
    // 加载左边数据
    [self loaddingCategoryData];
    
    // 刷新右边表格数据
    [self refreshUsersData];
}

#pragma mark - 设置tableView的属性
- (void)setupTableView
{
    // 设置标题和背景颜色
    self.navigationItem.title = @"推荐关注";
    self.view.backgroundColor = LSLCommenBGColor;
    
    self.categoryTableView.backgroundColor = LSLCommenBGColor;
    self.userTableView.backgroundColor = LSLCommenBGColor;
    
    // 注册
    [self.categoryTableView registerNib:[UINib nibWithNibName:@"LSLCategoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LSLCategoryCellID];
    [self.userTableView registerNib:[UINib nibWithNibName:@"LSLUserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LSLUserCellID];
    
    // 设置内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
}

#pragma mark - 刷新右边表格数据
- (void)refreshUsersData
{
    self.userTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddingUserDataWithCategory)];
    
    self.userTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUsers)];
}

#pragma mark - 右边加载更多数据
// 右边加载更多数据
- (void)refreshUsers
{
    // 取消之前的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    LSLCategory *category = LSLCategoryForSelectedRow;
    
    NSInteger page = category.currentPage;
    
    // 请求参数
    NSDictionary *dict = @{
                           @"a" : @"list",
                           @"c" : @"subscribe",
                           @"category_id" : @(category.categoryID),
                           @"page" : @(++page)
                           };
    
    // 弱引用
    LSLWeakSelf;
    // 发送请求
    [self.manager GET:LSLRequestURL parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        // 加载成功后修改页码
        category.currentPage = page;
        
        // 获取网络数据
        NSArray *users = [LSLUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        // 刷新表格
        [weakSelf.userTableView reloadData];
        
        // 让底部控制器结束刷新
        if (category.users.count >= category.total) {
            self.userTableView.footer.hidden = YES;
        }else{
            [self.userTableView.footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [self.userTableView.footer endRefreshing];
    }];
}

/** 加载右边数据 */
- (void)loaddingUserDataWithCategory
{
    // 取消之前的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 获取当前左边选中的类别
    LSLCategory *category = self.categorys[self.categoryTableView.indexPathForSelectedRow.row];
    
    // 请求参数
    NSInteger page = 1;
    NSDictionary *dict = @{
                           @"a" : @"list",
                           @"c" : @"subscribe",
                           @"category_id" : @(category.categoryID),
                           @"page" : @(page)
                           };
    
    // 弱引用
    LSLWeakSelf;
    // 发送请求
    [self.manager GET:LSLRequestURL parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        // 加载成功后，重新设置页码
        category.currentPage = page;
        
        // 1.判断是否有响应数据
        if (responseObject == nil) {
            // 弹出提示框
            [SVProgressHUD showErrorWithStatus:@"加载数据失败,请重新加载！"];
            return;
        }
        
        // 2.获取网络数据
        category.users = [LSLUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 总个数
        category.total = [responseObject[@"total"] integerValue];
        
        // 3.刷新表格
        [weakSelf.userTableView reloadData];
        
        // 结束刷新
        [self.userTableView.header endRefreshing];
        
        // 当当前个数等于总个数的时候，显示footer为已经加载完毕
        if (category.users.count >= category.total) {
            self.userTableView.footer.hidden = YES;
        }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [self.userTableView.header endRefreshing];
    }];
}

#pragma mark - 加载左边数据
- (void)loaddingCategoryData
{
    // 弹出提示框
    [SVProgressHUD show];
    
    // 请求参数
    NSDictionary *dict = @{
                           @"a":@"category",
                           @"c":@"subscribe"
                           };
    // 弱引用
    LSLWeakSelf;
    // 发送请求
    [weakSelf.manager GET:LSLRequestURL parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        // 1.判断是否有响应数据
        if (responseObject == nil) {
            // 弹出提示框
            [SVProgressHUD showErrorWithStatus:@"加载数据失败,请重新加载！"];
            return;
        }
        
        // 2.获取网络数据
        weakSelf.categorys = [LSLCategory objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 3.刷新表格
        [weakSelf.categoryTableView reloadData];
        
        // 默认选中首行
        [weakSelf.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // 第一次进来时，显示左边第一个对应的数据
        [weakSelf.userTableView.header beginRefreshing];
        
        // 4.关闭提示框
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 关闭提示框
        [SVProgressHUD dismiss];
    }];
}

/** 销毁窗口时，取消任务 */
- (void)dealloc
{
    [self.manager invalidateSessionCancelingTasks:YES];
}

#pragma mark - 数据源 <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) {
        return self.categorys.count;
    }else{
        NSInteger count = [LSLCategoryForSelectedRow users].count;
        // 判断是否需要显示底部
        self.userTableView.footer.hidden = (count == 0);
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
        LSLCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:LSLCategoryCellID];
        
        // 设置显示数据
        cell.category = self.categorys[indexPath.row];
        return cell;
    }else{
        LSLUserCell *cell = [tableView dequeueReusableCellWithIdentifier:LSLUserCellID];
        
        // 设置显示数据
        cell.recommendUser =  [LSLCategoryForSelectedRow users][indexPath.row];
        return cell;
    }
}

#pragma mark - 代理 <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
        LSLCategory *category = self.categorys[indexPath.row];
        
        // 只要点击了左边就刷新右边表格，加载右边数据,解决重复加载的问题
        [self.userTableView reloadData];
        
        // 当当前个数等于总个数的时候，显示footer为已经加载完毕
        if (category.users.count >= category.total) {
            self.userTableView.footer.hidden = YES;
        }
        
        if (category.users.count <= 0) { // 还没有数据时直接加载数据
            [self.userTableView.header beginRefreshing];
        }
    }
}
@end
