//
//  LSLConst.m 定义所有的全局常量
//
/**
 1.如果只在文件中使用的用：
 static 类型  const 变量名 = 常量值；
 
 2.如果是全世界都能访问的：
 (1)在congst常量.m文件定义:
 类型 const 常量名 = 常量值；
 (2)在.h中:
 #import "XMGConst.h"
 UIKIT_EXTERN 类型const 常量名
 (3)在pch文件中导入.h文件中:
 #import "LSLConst.h"
 */

#import <UIKit/UIKit.h>

/* 请求路劲 */
NSString * const LSLRequestURL = @"http://api.budejie.com/api/api_open.php";

/* 统一间距 */
NSInteger const LSLCommonMargin = 10;

/* 统一较小间距 */
NSInteger const LSLCommonSmallMargin = 5;

/* 导航栏最大的Y值 */
NSInteger const LSLNavigationBarMaxY = 64;

/* 导航栏标题的高度 */
NSInteger const LSLTitleHeight = 35;

/* tabBar的固定高度 */
NSInteger const LSLTabBarHeight = 49;

/* 标签的高度 */
NSInteger const LSLTagHeight = 25;

/* 帖子内容的Y值 */
NSInteger const LSLTopicContentY = 55;

/* 帖子工具条的高度 */
NSInteger const LSLToolBarHeight = 35;

/* 帖子最热评论顶部标题的高度 */
NSInteger const LSLCellHotCommentTitleHeight = 21;







