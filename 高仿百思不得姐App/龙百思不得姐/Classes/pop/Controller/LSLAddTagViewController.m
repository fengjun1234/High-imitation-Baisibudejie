//
//  LSLAddTagViewController.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/12.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLAddTagViewController.h"
#import "LSLTagButton.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "LSLTagTextField.h"

@interface LSLAddTagViewController ()<UITextFieldDelegate>
/** 标签内容view */
@property(nonatomic,strong)UIView *contentView;
/** 提醒按钮 */
@property(nonatomic,strong)LSLTagTextField *textFiled;
/** 提醒按钮 */
@property(nonatomic,strong)UIButton *tipBtn;
/** 标签按钮集合 */
@property(nonatomic,strong)NSMutableArray *tagBtns;
@end

@implementation LSLAddTagViewController
#pragma mark - 懒加载
- (NSMutableArray *)tagBtns
{
    if (!_tagBtns) {
        _tagBtns = [NSMutableArray array];
    }
    return  _tagBtns;
}

- (UIButton *)tipBtn
{
    if (!_tipBtn) {
        UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tipBtn.x = 0;
        tipBtn.width = self.contentView.width;
        tipBtn.height = LSLTagHeight;
        [tipBtn setBackgroundColor:LSLTagBtnBGColor];
        tipBtn.titleLabel.font  = [UIFont systemFontOfSize:15];
        tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        tipBtn.contentEdgeInsets = UIEdgeInsetsMake(0, LSLCommonSmallMargin, 0, 0);
        
        // 添加监听
        [tipBtn addTarget:self action:@selector(tipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _tipBtn = tipBtn;
        self.tipBtn = tipBtn;
        [self.contentView addSubview:self.tipBtn];
    }
    return _tipBtn;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置nav
    [self setupNav];
    
    // 标签内容view
    [self setupContentView];
    
    // 设置textField
    [self setupTextField];
    
    // 默认的两个标签按钮
    [self setupTagBtn];
}

#pragma mark - 默认的两个标签按钮
- (void)setupTagBtn
{
    // 默认标签
    for (NSString *tag in self.tags) {
        self.textFiled.text = tag;
        [self tipBtnClick];
    }
}


#pragma mark - 标签内容view
- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = LSLCommonSmallMargin;
    contentView.y = LSLNavigationBarMaxY + LSLCommonSmallMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.height = self.view.height;
    [self.view addSubview:contentView];
    
    self.contentView  = contentView;
}

#pragma mark - 设置textField
- (void)setupTextField
{
    LSLTagTextField *textField = [[LSLTagTextField alloc] init];
    textField.width = self.contentView.width;
    textField.height = LSLTagHeight;
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    // 给文本框设置代理
    textField.delegate = self;
    
    // 必须在设置完placeholder文字后才能设置placeholderLabel.textColor
    textField.placeholderColor = [UIColor grayColor];
    textField.textColor = [UIColor blackColor];
    
    [textField becomeFirstResponder];
    
    // 添加监听事件
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    LSLWeakSelf;
    textField.deleteBackwardOperation = ^{
        // 判断文本框是否还有文字
        if (weakSelf.textFiled.hasText) return ;
        
        // 删除完最后一个字符后，开始删除标签按钮
        [weakSelf tagBtnClick:weakSelf.tagBtns.lastObject];
    };
    
    [self.contentView addSubview: textField];
    self.textFiled = textField;
    
    // 刷新前提：这个子控件必须已经添加到父控件中
    [textField layoutIfNeeded];
}

// 监听文本框修改事件
- (void)textFieldEditingChanged:(LSLTagTextField *)textField
{
    if (textField.hasText) {
        // 获取最后一个字符
        NSString *lastChar = [textField.text substringFromIndex:textField.text.length - 1];
        
        // 判断是否为逗号
        if ([lastChar isEqualToString:@","]
            || [lastChar isEqualToString:@"，"]) {   // 是逗号
            // 去除逗号
//            self.textFiled.text = [textField.text substringToIndex:textField.text.length - 1];
            [self.textFiled deleteBackward];
            
            [self tipBtnClick];
        }else{  // 不是逗号
            // 设置文本框的位置
            [self setupTextFieldFrame];
            
            self.tipBtn.hidden = NO;
            self.tipBtn.y = CGRectGetMaxY(textField.frame) + LSLCommonSmallMargin;
            [self.tipBtn setTitle:[NSString stringWithFormat:@"添加标签：%@",textField.text] forState:UIControlStateNormal];
        }
    }else{
        self.tipBtn.hidden = YES;
    }
}

#pragma mark - 设置标签按钮的frame
/**
 *  设置标签按钮的frame
 *
 *  @param tagBtn          需要设置frame的标签按钮
 *  @param referenceTagBtn 计算tagBtn的frame时的参照标签按钮
 */
- (void)setTagBtnFrame:(LSLTagButton *)tagBtn referenceTagBtn:(LSLTagButton *)referenceTagBtn
{
    // 没有参照按钮 (tagBtn为第一个按钮时)
    if (referenceTagBtn == nil) {
        tagBtn.x = 0;
        tagBtn.y = 0;
        return;
    }
    
    // tagBtn不是第一个按钮时
    // 最后一个按钮加间距的长度
    CGFloat leftWidth = CGRectGetMaxX(referenceTagBtn.frame) + LSLCommonSmallMargin;
    // 右边剩余的长度
    CGFloat rightWidth = self.contentView.width - leftWidth;
    
    if (rightWidth >= tagBtn.width) { // 跟上一个标签同一行
        tagBtn.x = leftWidth;
        tagBtn.y = referenceTagBtn.y;
    }else{  // 换行
        tagBtn.x = 0;
        tagBtn.y = CGRectGetMaxY(referenceTagBtn.frame) + LSLCommonSmallMargin;
    }
}

#pragma mark - 设置textField的frame
- (void)setupTextFieldFrame
{
    // 文本框的长度
    CGFloat textW = [self.textFiled.text sizeWithAttributes:@{NSFontAttributeName : self.textFiled.font}].width;
    textW = MAX(100, textW);
    
    // 获取到最后一个标签按钮
    UIButton *lastTagBtn = self.tagBtns.lastObject;
    if (lastTagBtn == nil) {
        self.textFiled.x = 0;
        self.textFiled.y = 0;
    }else{
        // 最后一个按钮加间距的长度
        CGFloat width = CGRectGetMaxX(lastTagBtn.frame) + LSLCommonSmallMargin;
        
        // 右边剩余的长度
        CGFloat connetWidth = self.contentView.width - width;
        
        if (connetWidth >= textW) { // 和最后一个标签按钮同一行
            self.textFiled.x = width;
            self.textFiled.y = lastTagBtn.y;
        }else{  // 换行
            self.textFiled.x = 0;
            self.textFiled.y = CGRectGetMaxY(lastTagBtn.frame) + LSLCommonSmallMargin;
        }
    }
    
    // 布局提醒按钮的位置
    self.tipBtn.y = CGRectGetMaxY(self.textFiled.frame) + LSLCommonSmallMargin;
}

#pragma mark - 设置nav
- (void)setupNav
{
    // 标题和背景颜色
    self.title  = @"添加标签";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

#pragma mark - 监听
/** 取消 */
- (void)cancle
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/** 完成 */
- (void)done
{
    // 方法1：利用for循环遍历
    
    // 方法2:获取所有标签的text值
    NSArray *tags = [self.tagBtns valueForKeyPath:@"currentTitle"
                     ];
    
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    // 退出当前界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 提醒按钮的点击事件
- (void)tipBtnClick
{
    // 最多输入五个标签
    if (self.tagBtns.count >= 5 ){
        [SVProgressHUD showErrorWithStatus:@"最多可添加五个标签！" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    // 文本框没有值时直接返回
    if (self.textFiled.hasText == NO) return;
    
    // 创建一个标签按钮
    LSLTagButton *tagBtn = [LSLTagButton buttonWithType:UIButtonTypeCustom];
    [tagBtn setTitle:self.textFiled.text forState:UIControlStateNormal];
    // 添加监听
    [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加到界面中
    [self.contentView addSubview:tagBtn];
    
    // 设置标签按钮位置
    [self setTagBtnFrame:tagBtn referenceTagBtn:self.tagBtns.lastObject];
    
    // 添加到集合中
    [self.tagBtns addObject:tagBtn];
    
    // 清空文本框
    self.textFiled.text = nil;
    // 设置文本框的位置
    [self setupTextFieldFrame];
    
    // 隐藏提醒按钮
    self.tipBtn.hidden = YES;
}

/**
 *  点击了标签按钮,删除标签
 */
- (void)tagBtnClick:(LSLTagButton *)clickedTagBtn
{
    // 获取选择按钮的索引
    NSInteger index = [self.tagBtns indexOfObject:clickedTagBtn];
    
    // 删除标签按钮
    [clickedTagBtn removeFromSuperview];
    [self.tagBtns removeObject:clickedTagBtn];
    
    // 重新排布标签按钮
    for (NSInteger i = index; i < self.tagBtns.count; i++) {
        LSLTagButton *tagBtn = self.tagBtns[i];
        
        // 设置标签按钮位置
        LSLTagButton *previousTagBtn = (i == 0) ? nil : self.tagBtns[i - 1];
        [self setTagBtnFrame:tagBtn referenceTagBtn:previousTagBtn];
    }
    
    // 重新布局文本框的位置
    [self setupTextFieldFrame];
}

#pragma mark - <UITextFieldDelegate> 点击return按钮时事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self tipBtnClick];
    return YES;
}

@end
