//
//  LSLTabBar.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLTabBar.h"
#import "LSLPublishViewController.h"


@interface LSLTabBar()
/** 加号按钮*/
@property(nonatomic,weak)UIButton *btn;
@end
@implementation LSLTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加加号按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [btn sizeToFit];
        
        // 给按钮添加事件
        [btn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.btn = btn;
        [self addSubview:btn];
        
        // 设置tabBar的背景图片
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
    }
    return self;
}

// 按钮的点击事件
- (void)publishClick
{
    // 发布界面
    LSLPublishViewController *publicsVC = [[LSLPublishViewController alloc] init];
    
    [self.window.rootViewController presentViewController:publicsVC animated:YES completion:nil];
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 获取tabBar的高宽
    CGFloat height = self.height;
    CGFloat width = self.width;
    self.btn.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 序号
    int index = 0;
    
    // 设置UITabBarButton的frame
    CGFloat btnWidth = width / 5;
    CGFloat btnHeight = self.frame.size.height;
    CGFloat y = 0;

    // 设置tabBar子控件的frame
    for (UIView *tbBtn in self.subviews){
        // 判断是否为UITabBarButton类，否则返回
//        if (![tbBtn isKindOfClass:NSClassFromString(@"UITabBarButton")])  continue;
        if (![NSStringFromClass(tbBtn.class) isEqualToString:@"UITabBarButton"]) continue;
        
        CGFloat x = index * btnWidth;
        if (index >= 2) {
            // 计算x
            x += btnWidth;
        }
       
        tbBtn.frame = CGRectMake(x, y, btnWidth, btnHeight);
        
        // 序号递增
        index++;
    }
}

@end
