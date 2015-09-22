//
//  LSLSquareWebViewController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/7.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLSquareWebViewController.h"
#import "LSLSquare.h"

// 进度条高度
#define LSLLoaddingHeight 3

@interface LSLSquareWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
@property(nonatomic,strong) UIView *loaddingDataView;
// 创建一个定时器
@property(nonatomic,weak)NSTimer *timer;

@end

@implementation LSLSquareWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏属性
    [self setupNav];
    
    // 设置webviewe属性
    self.webView.backgroundColor = LSLCommenBGColor;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(64 + LSLLoaddingHeight, 0, 0, 0);
    
    // 创建创建进度条
    [self createLoadingView];
    
    // 加载页面
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.square.url]];
    [self.webView loadRequest: request];
}

#pragma mark - 设置导航栏属性
- (void)setupNav
{
    // 设置导航栏属性和背景颜色
    self.navigationItem.title  = self.square.name;
    self.view.backgroundColor = LSLCommenBGColor;
}

#pragma mark - 创建进度条
- (void)createLoadingView
{
    UIView *temView = [[UIView alloc] init];
    temView.backgroundColor = LSLARGBColor(255, 63, 117, 255);
    temView.frame = CGRectMake(0, 64, 0, LSLLoaddingHeight);
    [self.view addSubview:temView];
    self.loaddingDataView = temView;
    
    // 创建定时器
    [self createTimer];
}

// 创建定时器
- (void)createTimer
{
    // 重新开启进度条
    self.loaddingDataView.hidden = NO;
    
    // 创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadingWebView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 时刻修改进度条长度
static CGFloat const percent = 0.05;
- (void)loadingWebView
{
    if (self.loaddingDataView.width < (self.view.width * 0.95) ){
        [UIView animateWithDuration:0.5 animations:^{
            self.loaddingDataView.width += self.view.width * percent;
        }];
    }else{
        [self.timer invalidate];
    }
}

#pragma mark - 当页面加载完毕时的操作
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 加载完成时，加载进度条长度为100%，然后隐藏起来
    [UIView animateWithDuration:0.25 animations:^{
        self.loaddingDataView.width = self.view.width;
    } completion:^(BOOL finished) {
        self.loaddingDataView.hidden = YES;
        
        // 销毁定时
        [self.timer invalidate];
        
        // 按钮的状态
        self.back.enabled = self.webView.canGoBack;
        self.forward.enabled = self.webView.canGoForward;
        
        // 去除进度条后,恢复页面内边距
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }];
}

// 返回
- (IBAction)goBackClick
{
    // 进度条
    [self createTimer];
    
    [self.webView goBack];
}

// 前进
- (IBAction)goForwardClick
{
    // 进度条
    [self createTimer];
    
    [self.webView goForward];
}

// 刷新
- (IBAction)goRefreshClick
{
    // 进度条
    [self createTimer];
    
    [self.webView reload];
}
@end
