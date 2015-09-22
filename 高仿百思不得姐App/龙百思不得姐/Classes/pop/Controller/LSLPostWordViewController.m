//
//  LSLPostWordViewController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/11.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLPostWordViewController.h"
#import "LSLPostWordTexView.h"
#import "LSLPostWordToolBar.h"

@interface LSLPostWordViewController ()<UITextViewDelegate>
/** 文本框 */
@property(nonatomic,strong)LSLPostWordTexView *postWord;
/** 工具栏 */
@property(nonatomic,strong)LSLPostWordToolBar *toolBar;
@end

@implementation LSLPostWordViewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    // 创建输入框view
    [self setupTextView];
    
    // 创建工具栏
    [self setupToolBar];
}

#pragma mark - 创建工具栏
- (void)setupToolBar
{
    // 创建工具栏
    LSLPostWordToolBar *toolBar = [LSLPostWordToolBar viewFromXib];
    self.toolBar = toolBar;
    toolBar.x = 0;
    toolBar.y = self.view.height - toolBar.height;
    toolBar.width = self.view.width;
    [self.view addSubview:toolBar];
    
    // 创建通知，调整工具栏的位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 用通知，监听键盘弹出事件
- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    // 获取键盘弹出的事件
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 动画
    [UIView animateWithDuration:duration animations:^{
        CGFloat ty = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - LSLScreenHeight;
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}

/**
 *  移除通知
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置nav
- (void)setupNav
{
    // 标题
    self.title  = @"发表段子";
    
    self.view.backgroundColor = LSLCommenBGColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // 强制刷新，当某些控件设置了enabled属性失效时使用
    [self.navigationController.navigationBar layoutIfNeeded];
}

// 取消按钮时
- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 发表段子
- (void)post
{
    LSLFUNC;
}

#pragma mark - 设置输入框view
- (void)setupTextView
{
    // 创建输入框view
    LSLPostWordTexView *postWord = [[LSLPostWordTexView alloc] init];
    postWord.alwaysBounceVertical = YES;
    postWord.frame = self.view.bounds;
    postWord.backgroundColor = [UIColor whiteColor];
    postWord.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    postWord.placeholderColor = [UIColor grayColor];
    [self.view addSubview:postWord];
    
    self.postWord = postWord;
    self.postWord.delegate  = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.postWord becomeFirstResponder];
}

#pragma mark - <UITextViewDelegate> 拖拽时，结束编辑状态
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

/**
 *  当输入数据时显示“发表“按钮
 */
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}
@end
