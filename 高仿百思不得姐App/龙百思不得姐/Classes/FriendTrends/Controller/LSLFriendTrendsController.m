//
//  LSLFriendTrendsController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/1.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLFriendTrendsController.h"
#import "LSLLoginRegisterController.h"
#import "LSLRecommendViewController.h"


@interface LSLFriendTrendsController ()
/** long */
@property(nonatomic,weak)NSString *nameStr;
@end

@implementation LSLFriendTrendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.navigationItem.title = @"我的关注";
    
    self.view.backgroundColor = LSLCommenBGColor;

    // 设置导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highlightedImage:@"friendsRecommentIcon-click" target:self action:@selector(RecommendClick)];
}


// 点击按钮事件
- (void)RecommendClick
{
    LSLRecommendViewController *vc = [[LSLRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 显示登录注册界面
- (IBAction)loginRegisterClick:(UIButton *)sender
{
    LSLLoginRegisterController *loginV = [[LSLLoginRegisterController alloc] init];
    
    [self presentViewController:loginV animated:YES completion:nil];
}


@end
