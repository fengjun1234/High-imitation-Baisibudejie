//
//  LSLLoginRegisterController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/2.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLLoginRegisterController.h"

@interface LSLLoginRegisterController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLoginPace;
@end

@implementation LSLLoginRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置登录按钮的圆角
    // 方法1
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    
    // 注册按钮圆角
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.layer.masksToBounds = YES;
    
    /*
    // 方法2
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.clipsToBounds = YES;
    
    // 方法3
    [self.loginBtn setValue:@5 forKeyPath:@"layer.cornerRadius"];
    [self.loginBtn setValue:@YES forKeyPath:@"layer.masksToBounds"];}
     
    // 方法4
    // storyboard中实现
    */
}

// 注册按钮
- (IBAction)loginRegisterClick:(UIButton *)button {
    
    // 退出键盘
    [self.view endEditing:YES];
    
    if (self.leftLoginPace.constant == 0) {
        button.selected = YES;
        self.leftLoginPace.constant = - self.view.width;
    }else{
        button.selected = NO;
        self.leftLoginPace.constant = 0;
    }
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 *  关闭登录界面
 */
- (IBAction)closeLogin:(UIButton *)sender {
    // 退出键盘
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  设置状态栏为白色
 */
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

// 让UIApplication来管理状态栏的颜色
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

/**
 *  触摸屏幕时退出编辑状态
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
