//
//  AppDelegate.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "AppDelegate.h"
#import "LSLTabBarController.h"

@interface AppDelegate ()
/** 状态栏窗口 */
@property(nonatomic,strong)UIWindow *windowTow;
@end

@implementation AppDelegate
// 懒加载
- (UIWindow *)windowTow
{
    if (!_windowTow) {
        // 1.创建window窗口
        _windowTow = [[UIWindow alloc] init];
        _windowTow.hidden = NO;
        // 设置窗口的优先级 UIWindowLevelNormal < UIWindowLevelStatusBar < UIWindowLevelAlert
        _windowTow.windowLevel = UIWindowLevelAlert;
        _windowTow.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
        _windowTow.backgroundColor = [UIColor clearColor];
        [_windowTow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToTop)]];
        
#warning iOS9之后，每一个window都需要一个根控制器，而且状态栏归最上层的window管
        UIViewController *rootVC = [[UIViewController alloc] init];
        _windowTow.rootViewController = rootVC;
    }
    return _windowTow;
}

- (void)scrollToTop
{
    // 取出所有的window
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    // 遍历所有的子控件
    for (UIWindow *window in windows) {
        [self searchForSuperView:window];
    }
}

// 迭代实现遍历所有子控件
- (void)searchForSuperView:(UIView *)supView
{
    for (UIScrollView *scrollView in supView.subviews) {
        [self searchForSuperView:scrollView];   // 迭代
        
        // 如果是UIScrollView控件或其子控件，则执行回顶操作
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            // 首先判断当前scrollView是否在当前的窗口window上(多种方式)
//            CGRect scrollViewRect = [scrollView convertRect:scrollView.bounds toView:self.window];
//            CGRect scrollViewRect = [self.window convertRect:scrollView.frame fromView:scrollView.superview];
            CGRect scrollViewRect = [self.window convertRect:scrollView.bounds fromView:scrollView];
            CGRect windowRect = self.window.bounds;
            
            // 如果在则让scrollView回顶
            if (CGRectContainsRect(scrollViewRect, windowRect)) {
                CGPoint scrollViewPoint = scrollView.contentOffset;
                
                scrollViewPoint.y = - scrollView.contentInset.top;  // 回滚到顶部
                
                [scrollView setContentOffset:scrollViewPoint animated:YES];
            }
        }
    }
}

/** 当系统启动完成后调用 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.定义显示的窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor redColor];
    
    // 2.设置根控制器
    self.window.rootViewController = [[LSLTabBarController alloc] init];
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}

/** 程序激活的时候调用一次 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 点击状态栏位置，回滚到最顶部
    [self windowTow];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
