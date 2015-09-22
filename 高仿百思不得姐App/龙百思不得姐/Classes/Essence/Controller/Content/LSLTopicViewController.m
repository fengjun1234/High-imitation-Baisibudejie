//
//  LSLTopicViewController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/14.
//  Copyright (c) 2015年 longshao. Topic rights reserved.
//

#import "LSLTopicViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh.h>
#import "LSLTopic.h"
#import "UIImageView+LSLExtension.h"
#import "LSLTopicCell.h"
#import "LSLCommentViewController.h"
#import "LSLNewControllerViewController.h"

@interface LSLTopicViewController ()
/* 数据模型 */
@property(nonatomic,strong)NSMutableArray *topics;
/* 请求管理 */
@property(nonatomic,weak)AFHTTPSessionManager *manager;
/** 加载下一页标签 */
@property(nonatomic,strong)NSString *maxtime;
@end

/** 帖子cell的ID */
static NSString * const LSLTopicCellID = @"topicCell";

@implementation LSLTopicViewController

/** 这个方法时只是为了去掉警告，具体的实现在子类中*/
- (LSLTopicType)type
{
    return LSLTopicTypeAll;
}

#pragma mark - 懒加载
- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return  _topics;
}

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
    
    // 设置table的属性
    [self setupTabel];
    
    // 进入界面时刷新
    [self refreshTableView];
}

#pragma mark - 进入界面时刷新
- (void)refreshTableView
{
    // 下拉刷新帖子
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewTopics)];
    self.tableView.header.automaticallyChangeAlpha = YES; // 自动改变透明度
    [self.tableView.header beginRefreshing];
    
    
    // 上拉加载更多帖子
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loaddingMoreTopics)];
}

// 上拉加载更多帖子
- (void)loaddingMoreTopics
{
    // 取消之前所有请求,会自动调用failure的Block方法
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSDictionary *dict = @{
                           @"a": [self aParam],
                           @"c":@"data",
                           @"type":@(self.type),
                           @"maxtime": self.maxtime
                           };
    // 弱引用
    LSLWeakSelf;
    // 发送请求
    [self.manager GET:LSLRequestURL parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        LSLWriteToPlist(responseObject, @"topics");
        // 获取更多数据
        NSArray *moreTopics = [LSLTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.topics addObjectsFromArray:moreTopics];
        
        // 保存加载下一页的标签
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 判断是否为最后一页帖子
        if (self.topics.count >= [responseObject[@"info"][@"maxid"] intValue]) {
            [self.tableView.footer noticeNoMoreData];
        }else {
            // 关闭刷新
            [weakSelf.tableView.footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 关闭刷新
        [weakSelf.tableView.footer endRefreshing];
    }];
}

/** 获取当前控制器类型,来决定获取数据是精华还是新帖 */
- (NSString *)aParam
{
    if ([self.parentViewController isKindOfClass:[LSLNewControllerViewController class]])
    {
        return @"newlist";
    }
    return @"list";
}

// 下拉刷新帖子
- (void)refreshNewTopics
{
    // 取消之前所有请求,会自动调用failure的Block方法
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    
    
    
    // 请求参数
    NSDictionary *dict = @{
                           @"a":[self aParam],
                           @"c":@"data",
                           @"type":@(self.type)
                           };
    // 弱引用
    LSLWeakSelf;
    // 发送请求
    [self.manager GET:LSLRequestURL parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        // 获取数据
        weakSelf.topics = [LSLTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 保存加载下一页的标签
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 判断是否为最后一页帖子
        if (self.topics.count >= [responseObject[@"info"][@"maxid"] intValue]) {
            [self.tableView.footer noticeNoMoreData];
        }
        
        // 关闭刷新
        [weakSelf.tableView.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 关闭刷新
        [weakSelf.tableView.header endRefreshing];
    }];
}

#pragma mark - 设置table的属性
- (void)setupTabel
{
    // 设置table的属性：背景颜色、内容内边距、滚动条内边距
    self.tableView.backgroundColor = LSLCommenBGColor;
    self.tableView.contentInset = UIEdgeInsetsMake(LSLNavigationBarMaxY + LSLTitleHeight, 0, LSLTabBarHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 去除cell之间的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSLTopicCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LSLTopicCellID];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSLTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:LSLTopicCellID];
    
    // 显示数据
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSLTopic *topic = self.topics[indexPath.row];
    return topic.cellHeight;
}

// push出帖子详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建帖子详情界面
    LSLCommentViewController *commentVC = [[LSLCommentViewController alloc] init];
    
    // 给对象传递数据
    commentVC.topic = self.topics[indexPath.row];
    
    // push帖子详情界面
    [self.navigationController pushViewController:commentVC animated:YES];
}
@end
