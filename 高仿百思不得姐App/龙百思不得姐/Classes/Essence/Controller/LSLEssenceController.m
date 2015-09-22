//
//  LSLEssenceController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLEssenceController.h"
#import "LSLMainTagController.h"
#import "LSLTitleButton.h"
#import "LSLALLViewController.h"
#import "LSLVideoViewController.h"
#import "LSLAudioViewController.h"
#import "LSLPictureViewController.h"
#import "LSLWordViewController.h"

@interface LSLEssenceController ()<UIScrollViewDelegate>
/** scrollViwe的作用：用来存放tableView */
@property(nonatomic,weak)UIScrollView *scrollView;
/** 标题view */
@property(nonatomic,weak)UIView *titleView;
/** 标题指示器view */
@property(nonatomic,weak)UIView *titleBottomView;
/** 当前选中的标题按钮 */
@property(nonatomic,strong)LSLTitleButton *previousSelectedTitleBtn;
/** 标题按钮数组 */
@property(nonatomic,strong)NSMutableArray *titleBtns;
@end

@implementation LSLEssenceController
#pragma mark - 懒加载
- (NSMutableArray *)titleBtns
{
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setupNav];
    
    // 创建tableViewControll
    [self setupTableVCs];
    
    // 创建scrollview
    [self setupScrollView];
    
    // 创建导航栏
    [self setupTitleView];
}

#pragma mark - 创建tableViewControll
- (void)setupTableVCs
{
    LSLALLViewController *allVC = [[LSLALLViewController alloc] init];
    allVC.title = @"全部";
    [self addChildViewController:allVC];
    
    LSLVideoViewController *videoVC = [[LSLVideoViewController alloc] init];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    
    LSLAudioViewController *audioVC = [[LSLAudioViewController alloc] init];
    audioVC.title = @"声音";
    [self addChildViewController:audioVC];
    
    LSLPictureViewController *pictureVC = [[LSLPictureViewController alloc] init];
    pictureVC.title = @"图片";
    [self addChildViewController:pictureVC];
    
    LSLWordViewController *wordVC = [[LSLWordViewController alloc] init];
    wordVC.title = @"段子";
    [self addChildViewController:wordVC];
}

#pragma mark - 设置导航条
- (void)setupNav
{
    // 设置标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highlightedImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}

#pragma mark - 创建scrollview
- (void)setupScrollView
{
    // 时scrollview不会自动的调整内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = LSLCommenBGColor;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 设置默认显示第0个标题控件
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
}

#pragma mark  - 创建导航栏（标题栏）
- (void)setupTitleView
{
    // 1.创建导航栏view
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, LSLNavigationBarMaxY, self.view.width, LSLTitleHeight);
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    // 2.创建导航栏view内的标题内容
    // 标题的个数
    NSInteger titlesCount = self.childViewControllers.count;
    
    // 计算按钮高宽
    CGFloat btnW = self.titleView.width / titlesCount;
    CGFloat btnH = self.titleView.height;
    
    // 开始布局标题按钮
    for (int i = 0; i < titlesCount; i++) {
        // 创建标题按钮
        LSLTitleButton *titleBtn = [LSLTitleButton buttonWithType:UIButtonTypeCustom];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
 
        // 文字
        [titleBtn setTitle:[self.childViewControllers[i] title] forState:UIControlStateNormal];
        
        // 设置位置
        titleBtn.y = 0;
        titleBtn.width = btnW;
        titleBtn.height = btnH;
        titleBtn.x = i * titleBtn.width;
        
        // 添加到导航栏view中
        [self.titleView addSubview:titleBtn];
        [self.titleBtns addObject:titleBtn];
    }
    
    // 3.创建底部指示器view
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [self.titleBtns.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.y = self.titleView.height - titleBottomView.height;
    titleBottomView.height = 1;
    
    // 添加到导航栏view中
    [self.titleView addSubview:titleBottomView];
    self.titleBottomView = titleBottomView;
    
    // 4.默认选中第一个按钮,因为到这里时，标题按钮还没有画到view中，所以需要我们自己计算一下titleLabel的尺寸
    LSLTitleButton *firstTitleBtn = self.titleBtns.firstObject;
    [firstTitleBtn.titleLabel sizeToFit];
    self.titleBottomView.width = firstTitleBtn.titleLabel.width;
    self.titleBottomView.centerX = firstTitleBtn.centerX;
    [self titleBtnClick:self.titleBtns.firstObject];
}

#pragma mark - 监听
- (void)titleBtnClick:(LSLTitleButton *)titleBtn
{
    // 选中被点击按钮，取消先去选中的按钮属性
    self.previousSelectedTitleBtn.selected = NO;
    titleBtn.selected = YES;
    self.previousSelectedTitleBtn = titleBtn;
    
    // 修改指示器view的位置,必须先设置viwe的宽度，再设置centerX
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.width = titleBtn.titleLabel.width;
        self.titleBottomView.centerX = titleBtn.centerX;
    }];
    
    // 移动scrollView对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.view.width * [self.titleBtns indexOfObject:titleBtn];
    [self.scrollView setContentOffset:offset animated:YES];
}

// 点击按钮事件，推出新界面
- (void)tagClick
{
    LSLMainTagController *mainTagC = [[LSLMainTagController alloc] init];
    
    mainTagC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:mainTagC animated:YES];
}

#pragma mark - <UIScrollViewDelegate>代理
/**
 *  当scrollview滚动停止的时候调用（一般调用了setContentOffset:animated:方法且，滚动范围不为0的时候才会调用）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获取当前位置的子控件
    int index = scrollView.contentOffset.x / self.scrollView.width;
    UITableViewController *tableVC = self.childViewControllers[index];
    
    // 当创建完一次后，判断view是否在scrollview中的多种方法：
    if (tableVC.view.superview) return;
//    if (tableVC.isViewLoaded) return;
//    if (tableVC.view.window) return;
    
    // 设置位置
    tableVC.view.frame = scrollView.bounds;
    [scrollView addSubview:tableVC.view];
}

/**
 *  手动拖拽scrollview结束的时候调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    int index = scrollView.contentOffset.x / self.scrollView.width;
    [self titleBtnClick:self.titleBtns[index]];
}


@end
