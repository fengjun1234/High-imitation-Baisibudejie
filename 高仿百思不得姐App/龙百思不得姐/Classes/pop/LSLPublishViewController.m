//
//  LSLPublishViewController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/11.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLPublishViewController.h"
#import "LSLPostWordViewController.h"
#import "LSLNavigationController.h"
#import "LSLPublishButton.h"
#import <pop/POP.h>

/** 动画回弹间距 */
static NSInteger const LSLPopMagin = 10;
@interface LSLPublishViewController ()
/** 标语 */
@property(nonatomic,weak)UIImageView *sloganView;
/** 动画时间 */
@property(nonatomic,strong)NSArray *times;
/** 按钮 */
@property(nonatomic,strong)NSMutableArray *btns;
@end

@implementation LSLPublishViewController
#pragma mark - 懒加载
- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSArray *)times
{
    if (!_times) {
        CGFloat interval = 0.1; // 时间间隔
        _times = @[
                   @(5 * interval),
                   @(4 * interval),
                   @(3 * interval),
                   @(2 * interval),
                   @(0 * interval),
                   @(1 * interval),
                   @(6 * interval) // 标题的动画时间
                   ];
    }
    return _times;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注意点：2.一开始时禁止用户交互
    self.view.userInteractionEnabled = NO;
    
    // 添加按钮
    [self setupButtons];
    
    // 标题
    [self setupTitleImageView];
}

#pragma mark - 添加按钮
- (void)setupButtons
{
    // 按钮图片
    NSArray *pictures = @[@"publish-video",@"publish-picture",@"publish-text",@"publish-audio",@"publish-review",@"publish-offline",];
    
    // 按钮标题
    NSArray *titles = @[@"发视频",@"发图片",@"发段子",@"声音",@"审帖",@"离线下载",];
    
    // 常量
    NSInteger counts = pictures.count;
    int maxClosCounts = 3; //每行的列数
    NSInteger rowCounts = (counts + maxClosCounts - 1) / maxClosCounts; // 行数
    
    // 计算高宽
    CGFloat btnW = LSLScreenWidth / maxClosCounts;
    CGFloat btnH = btnW * 0.85;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat magin = (LSLScreenHeight - btnH * rowCounts) / 2;
    
    for (int i = 0; i < counts; i++) {
        // 创建按钮
        LSLPublishButton *btn = [LSLPublishButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.width = -1; // 注意点：1.按钮的尺寸为0，还是能看见文字缩成一个点，设置按你的饿尺寸wierd负数，那么就看不见文字了
        [self.view addSubview:btn];
        [self.btns addObject:btn];
        
        // 布局按钮
        btnX = (i % maxClosCounts) * btnW;
        btnY = (i / maxClosCounts) * btnH + magin;
//        btn.frame = CGRectMake(btnX, btnY, btnW, btnH); // 一开始先不设按钮的位置和尺寸
        
        // 设置数据
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:pictures[i]] forState:UIControlStateNormal];
        
        // 动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(btnX, - LSLScreenHeight, btnW, btnH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnY, btnW, btnH)];
        anim.springSpeed = LSLPopMagin;
        anim.springBounciness = LSLPopMagin;
        // CACurrentMediaTime()获取当前时间
        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        
        [btn pop_addAnimation:anim forKey:nil];
    }
}

#pragma mark - 标题
- (void)setupTitleImageView
{
    CGFloat sloganY = LSLScreenHeight * 0.2;
    
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.centerX = LSLScreenWidth * 0.5;
    sloganView.y = sloganY - LSLScreenHeight;
    
    [self.view addSubview:sloganView];
    self.sloganView = sloganView;
    
    // 动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(sloganY);
    anim.springSpeed = LSLPopMagin;
    anim.springBounciness = LSLPopMagin;
    // CACurrentMediaTime()获取当前时间
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    
    // 加载完成时恢复用户交互
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
}

#pragma mark - 退出动画
- (void)exit:(void (^)())task
{
    // 在退出过程中，禁止用户继续交互
    self.view.userInteractionEnabled = NO;
    
    // 按钮的退出动画
    for (int i = 0; i < self.btns.count; i++) {
        LSLPublishButton *btn = self.btns[i];
        
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        anim.toValue = @(btn.layer.position.y + LSLScreenHeight);
        // CACurrentMediaTime()获取当前时间
        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        
        [btn.layer pop_addAnimation:anim forKey:nil];
    }
    
    // 标题的退出动画
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(self.sloganView.layer.position.y + LSLScreenHeight);
    // CACurrentMediaTime()获取当前时间
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
        // 退出当前view
        [self dismissViewControllerAnimated:YES completion:nil];
        
        // 执行其他操作
        !task ? : task();
    }];
    
    [self.sloganView pop_addAnimation:anim forKey:nil];
}

#pragma mark - 监听点击
// 点击操作按钮事件
- (void)btnClick:(LSLPublishButton *)btn
{
    [self exit:^{
        // 获取按钮对应的数组下标
        NSInteger index = [self.btns indexOfObject:btn];
        switch (index) {
            case 0:
                LSLLog(@"%@",@"发视频");
                break;
            case 1:
                LSLLog(@"%@",@"发图片");
                break;
            case 2:{
                    LSLPostWordViewController *postWordVC = [[LSLPostWordViewController alloc] init];
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[LSLNavigationController alloc] initWithRootViewController:postWordVC] animated:YES completion:nil];
                    break;
                }
            case 3:
                LSLLog(@"%@",@"声音");
                break;
            case 4:
                LSLLog(@"%@",@"审帖");
                break;
            default:
                LSLLog(@"%@",@"离线下载");
                break;
        }
        
    }];
}

// 测试取消按钮，调到文本编辑界面
- (IBAction)cancleBtnClick:(id)sender
{
    [self exit:nil];
}

// 点击屏幕时，退出此界面
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self exit:nil];
}

@end
