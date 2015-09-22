//
//  LSLMeFooterView.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/7.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLMeFooterView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MJExtension/MJExtension.h>
#import "LSLSquare.h"
#import "LSLSquareButton.h"
#import "LSLSquareWebViewController.h"

@implementation LSLMeFooterView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor blueColor];
        
        // 请求参数
        NSDictionary *dict = @{
                               @"a":@"square",
                               @"c":@"topic"
                               };
        // 弱引用
        LSLWeakSelf;
        [[AFHTTPSessionManager manager] GET:LSLRequestURL parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            // 根据返回的数据，创建按钮
           [weakSelf createButton:[LSLSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]]];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }
    return  self;
}

- (void)createButton:(NSArray *)squares
{
    // 列数
    NSInteger count = 4;
    
    // 按钮的宽高
    CGFloat btnW = self.width / count;
    CGFloat btnH = btnW + 10;
    
    for (int i = 0 ; i < squares.count; i++) {
        LSLSquareButton *btn = [LSLSquareButton buttonWithType:UIButtonTypeCustom];
        
        // 绑定事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat x = btnW * (i % count);
        CGFloat y = btnH * (i / count);
        btn.frame = CGRectMake(x, y, btnW, btnH);
        
        // 设置数据
        btn.square = squares[i];
        
        [self addSubview:btn];
        
        // 设置view的高
        self.height = CGRectGetMaxY(btn.frame);
    }

    // 重新设置tableView的contentSize
    UITableView *tableV = (UITableView *)self.superview;
    tableV.contentSize = CGSizeMake(0, CGRectGetMaxY(self.frame));
}

- (void)btnClick:(LSLSquareButton *)button
{
    NSString *url = button.square.url;
    
    // 跳转到详情界面
    if ([url hasPrefix:@"http"]) {
        LSLSquareWebViewController *squareWebVC = [[LSLSquareWebViewController alloc] init];
        
        squareWebVC.square = button.square;
        
        UITabBarController *rootVC = (UITabBarController *)self.window.rootViewController;
        
        UINavigationController *nav = (UINavigationController *)rootVC.selectedViewController;
        
        [nav pushViewController:squareWebVC animated:YES];
    }
}

@end
