//
//  LSLTabBarController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLTabBarController.h"
#import "LSLEssenceController.h"
#import "LSLFriendTrendsController.h"
#import "LSLMeController.h"
#import "LSLNewControllerViewController.h"
#import "LSLTabBar.h"
#import "LSLNavigationController.h"

@interface LSLTabBarController ()

@end

@implementation LSLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置TabBar的属性
    [self setUpTabBarItemAttr];
    
    // 添加子控制器
    [self setUpChildsView];
    
    // 自定义TabBar,添加了加号按钮
    [self setUpTabBar];
}

/**
 *  自定义TabBar,添加了加号按钮
 */
- (void)setUpTabBar
{
    [self setValue:[[LSLTabBar alloc] init] forKeyPath:@"tabBar"];
}

/**
 *  添加子控制器
 */
- (void)setUpChildsView
{
    // 精华界面
    [self setUpChildView:[[LSLEssenceController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    // 新帖界面
    [self setUpChildView:[[LSLNewControllerViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    // 关注界面
    [self setUpChildView:[[LSLFriendTrendsController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    // 我的界面
    [self setUpChildView:[[LSLMeController alloc] initWithStyle:UITableViewStyleGrouped] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
}

/**
 *  添加子控制器
 *
 *  @param vc            UINavigationController的自控自弃
 *  @param title         标题
 *  @param image         nomal状态下的图片
 *  @param selectedImage selected状态下的图片
 */
- (void)setUpChildView:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage;
{
    LSLNavigationController *nav = [[LSLNavigationController alloc] initWithRootViewController:vc];
    nav.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    [self addChildViewController:nav];
}

/**
 *  设置TabBar的属性
 *  统一给所有的UITabBarItem设置文字属性
 *  只有后面带UI_APPEARANCE_SELECTOR的属性或方法，才可以通过appearance类方法来统一设置
 */
- (void)setUpTabBarItemAttr
{
    UITabBarItem *item = [UITabBarItem appearance];
    
    // UIControlStateNormal状态下的属性
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    // 设置字体颜色
    normalAttr[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 设置字体大小
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // UIControlStateSelected状态下的属性
    NSMutableDictionary *selectAttr = [NSMutableDictionary dictionary];
    selectAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    [item setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
}



@end
