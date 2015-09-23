//
//  LSLCommentViewController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/17.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLCommentViewController.h"
#import "LSLTopicCell.h"
#import "LSLTopic.h"
#import "LSLCommentCell.h"
#import "LSLComment.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "LSLHeaderFooterView.h"
#import "LSLCommentUser.h"

@interface LSLCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
// 工具栏约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolViewY;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 最热评论 */
@property(nonatomic,weak) LSLComment *hotComment;
/* 请求管理 */
@property(nonatomic,weak)AFHTTPSessionManager *manager;
/* 最热评论数据 */
@property(nonatomic,strong)NSMutableArray *hotComments;
/* 最新评论数据 */
@property(nonatomic,strong)NSMutableArray *lastsComments;
@end

/** 第一个cell */
static NSString * const LSLCommentHeaderCellID = @"topicCell";
/** 其他cell */
static NSString * const LSLCommentCellID = @"commentCell";
/** tableview的头部标识 */
static NSString * const LSLTableViewHeaderID = @"header";

@implementation LSLCommentViewController
#pragma mark - 懒加载

- (NSMutableArray *)hotComments
{
    if (!_hotComments) {
        _hotComments = [NSMutableArray array];
    }
    return _hotComments;
}

- (NSMutableArray *)lastsComments
{
    if (!_lastsComments) {
        _lastsComments = [NSMutableArray array];
    }
    return _lastsComments;
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
    // 设置导航条
    [self setupNav];
    
    // 设置table
    [self setupTabel];
    
    // 刷新界面
    [self refreshTableView];
}

// 刷新界面
- (void)refreshTableView
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComment)];
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComment)];
}

#pragma mark - 上拉加载更多
- (void)loadMoreComment
{
    // 取消之前所有请求,会自动调用failure的Block方法
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSDictionary *parameter = @{
                                @"a" : @"dataList",
                                @"c" : @"comment",
                                @"data_id" : self.topic.ID,
                                @"lastcid" : [self.lastsComments.lastObject ID],
                                };
    
    // 弱引用
    LSLWeakSelf;
    // 发送请求
    [self.manager GET:LSLRequestURL parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        // 加载更多数据
        NSArray *moreComments = [LSLComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.lastsComments addObjectsFromArray:moreComments];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 判断是否还有更多评论
        if (self.lastsComments.count >= [responseObject[@"total"] intValue]) {
            // 已经没有更多评论了
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

#pragma mark - 下拉刷新
- (void)loadNewComment
{
    // 取消之前所有请求,会自动调用failure的Block方法
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSDictionary *parameter = @{
                               @"a" : @"dataList",
                               @"c" : @"comment",
                               @"data_id" : self.topic.ID,
                               @"hot" : @1,
                               };
    
    // 弱引用
    LSLWeakSelf;
    // 发送请求
    [self.manager GET:LSLRequestURL parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        // 如果没有评价时
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 关闭刷新
            [weakSelf.tableView.header endRefreshing];
            
            // 直接返回
            return ;
        }
        
        // 获取数据
        weakSelf.hotComments = [LSLComment objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        weakSelf.lastsComments = [LSLComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 判断是否还有更多评论
        if (self.lastsComments.count >= [responseObject[@"total"] intValue]) {
            // 已经没有更多评论了
            [self.tableView.footer noticeNoMoreData];
        }
        
        // 关闭刷新
        [weakSelf.tableView.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 关闭刷新
        [weakSelf.tableView.header endRefreshing];
    }];
}

// 设置table
- (void)setupTabel
{
    // 设置背景颜色
    self.tableView.backgroundColor = LSLCommenBGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 设置tableview表头
    // 清空最热评论
    if (self.topic.hotComent) {
        self.hotComment = self.topic.hotComent;
        self.topic.hotComent = nil;
        self.topic.cellHeight = 0;
    }
    
    // 创建帖子cell
    LSLTopicCell *cell = [LSLTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, LSLScreenWidth, self.topic.cellHeight);
    
    // 设置header
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = LSLCommenBGColor;
    header.height = cell.height +  2 * LSLCommonMargin;
    [header addSubview:cell];
    
    self.tableView.tableHeaderView = header;
}

#pragma mark - 设置导航条和监听键盘事件
- (void)setupNav
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highlightedImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    // 创建通知，调整工具栏的位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LSLCommentCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LSLCommentCellID];
}

// 用通知，监听键盘弹出事件
- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    // 修改工具栏的位置
    CGFloat ty = LSLScreenHeight - [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    self.toolViewY.constant = ty;
    
    LSLWeakSelf;
    // 动画
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

/** 移除通知 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.hotComment) {
        // 销毁此界面的时候重写计算cell的高度
        self.topic.hotComent = self.hotComment;
        self.topic.cellHeight = 0;
    }
}

#pragma mark - <UIScrollViewDelegate>的代理方法
// 拖动屏幕隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hotComments.count) return 2;
    if (self.lastsComments.count) return 1;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.hotComments.count) return self.hotComments.count;
    else return self.lastsComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:LSLCommentCellID];
    cell.comment = self.lastsComments[indexPath.row];
    if(indexPath.section == 0 && self.hotComments.count){
        cell.comment = self.hotComments[indexPath.row];
    }
    return cell;
}

#pragma mark - 设置tbleview的组头
// 组头内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 优化：循环使用
    LSLHeaderFooterView *headerView = (LSLHeaderFooterView *)[tableView dequeueReusableCellWithIdentifier:LSLTableViewHeaderID];
    
    if (!headerView) {
        headerView = [[LSLHeaderFooterView alloc] initWithReuseIdentifier:LSLTableViewHeaderID];
    }
    
    if (section == 0 && self.hotComments.count){
        headerView.text = @"最热评论";
        return headerView;
    }else if (self.lastsComments.count) {
        headerView.text = @"最新评论";
        return headerView;
    }else {
        return nil;
    }
}

#pragma mark - <UITableViewDelegate>代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建弹出框
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    // 2.显示的内容
    menu.menuItems = @[
                       [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)],
                       [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)],
                       [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)],
                       ];
    // 3.显示的位置
    // 取出当前cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [menu setTargetRect:CGRectMake(0, cell.height * 0.5, cell.width, 1) inView:cell];
    
    // 4.显示出来
    [menu setMenuVisible:YES animated:YES];
}
#pragma mark - 获取当前选中的cell的数据
- (LSLComment *)selectedCellComment
{
    // 获取选中的cell的行号
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSInteger row = indexPath.row;
    
    // 获取行号对应的数据
    NSArray *comments = self.lastsComments;
    if (indexPath.section == 0 && self.hotComments.count > 0) {
        comments = self.hotComments;
    }
    
    return comments[row];
}

#pragma mark - UIMenuController事件
/** 当前控制器是否可以成为第一响应者 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/** 控制显示的内容 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (!self.isFirstResponder) { // 文本框弹出键盘, 文本框才是第一响应者
        if (action == @selector(ding:)
            || action == @selector(reply:)
            || action == @selector(warn:)) {
            return NO;
        }
    }
    
    return [super canPerformAction:action withSender:sender];
}

// 顶
- (void)ding:(UIMenuController *)menu
{
    LSLLog(@"顶:%@---%@",[self selectedCellComment].user.username,[self selectedCellComment].content);
}

// 回复
- (void)reply:(UIMenuController *)menu
{
     LSLLog(@"回复:%@---%@",[self selectedCellComment].user.username,[self selectedCellComment].content);
}

// 举报
- (void)warn:(UIMenuController *)menu
{
     LSLLog(@"举报:%@---%@",[self selectedCellComment].user.username,[self selectedCellComment].content);
}
@end
