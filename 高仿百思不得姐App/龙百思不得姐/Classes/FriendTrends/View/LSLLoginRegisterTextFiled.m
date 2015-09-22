//
//  LSLLoginRegisterTextFiled.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/2.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLLoginRegisterTextFiled.h"

// 占位文字颜色
#define LSLPlaceholderColorKey @"placeholderLabel.textColor"
// 默认的占位文字颜色
#define LSLPlaceholderDefaultColor [UIColor grayColor]
// 聚焦的占位文字颜色
#define LSLPlaceholderFocusColor [UIColor whiteColor]

@interface LSLLoginRegisterTextFiled()<UITextFieldDelegate>
@end

@implementation LSLLoginRegisterTextFiled

- (void)awakeFromNib
{
    // 设置文字的颜色
    self.textColor = LSLPlaceholderFocusColor;
    
    // 设置光标的颜色
    self.tintColor = LSLPlaceholderFocusColor;
    
    // 设置带属性的占位文字的颜色
    [self setupPlaceholderDefalutColor];
    
    // 实现对输入框的事件监听的4中方法
    [self resignFirstResponder];
}

#pragma mark - 设置占位符的颜色
- (void)setupPlaceholderDefalutColor
{
    self.placeholderColor = LSLPlaceholderDefaultColor;
}

- (void)setupPlaceholderFocusColor
{
    self.placeholderColor = LSLPlaceholderFocusColor;
}

#pragma mark - 方法4，重写文本框获得焦点时和失去焦点时的方法
- (BOOL)becomeFirstResponder
{
    // 获得焦点时高亮
    [self setupPlaceholderFocusColor];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    // 失去焦点时变灰色
    [self setupPlaceholderDefalutColor];
    return [super resignFirstResponder];
}


#pragma mark - 实现对输入框的事件监听的4中方法
- (void)setTextFieldClick
{
    /*
     // 方法1，用代理实现,这种方式不推荐，因为delegate实现很容易被外界覆盖
     self.delegate = self;
     
     // 方法2，分别给文本框编辑开始和结束时绑定事件
     [self addTarget:self action:@selector(beginEditing) forControlEvents:UIControlEventEditingDidBegin];
     [self addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventEditingDidEnd];
     
     // 方法3，通过通知，监听文本框编辑开始和结束
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing) name:UITextFieldTextDidBeginEditingNotification object:self];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing) name:UITextFieldTextDidEndEditingNotification object:self];
     
     // 方法4，重写文本框获得焦点时的becomeFirstResponder方法和失去焦点时的resignFirstResponder方法
     */
}

// 一定要在对象销毁之前移除监听
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - (方法1，用代理实现)实现UITextFieldDelegate方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 获得焦点时高亮
    [self setupPlaceholderFocusColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 失去焦点时变灰色
    [self setupPlaceholderDefalutColor];
}

#pragma mark - 方法2或3，文本框编辑开始和结束时对应的事件
- (void)beginEditing
{
    // 获得焦点时高亮
    [self setupPlaceholderFocusColor];
}

- (void)endEditing
{
    // 失去焦点时变灰色
    [self setupPlaceholderDefalutColor];
}

#pragma mark - 设置带属性的占位文字的颜色
- (void)setPlaceholderAttr
{
    /*
     // 设置带属性的占位文字的颜色
     // 方法1
     self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
     // 或
     NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
     attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
     self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
     
     // 方法2
     NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
     [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, self.placeholder.length)];
     self.attributedPlaceholder  =attrStr;
     
     // 富文本的扩展，可实现图文混排
     NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
     
     // 第一段文字
     NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:self.placeholder];
     [attrString appendAttributedString:str1];
     
     // 第二段图片
     NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
     attachment.image = [UIImage imageNamed:@"nav_coin_icon_click"];
     NSAttributedString *str2 = [NSAttributedString attributedStringWithAttachment:attachment];
     [attrString appendAttributedString:str2];
     
     // 第三段文字
     NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"您好"];
     [attrString appendAttributedString:str3];
     
     self.attributedPlaceholder = attrString;
     
     // 方法3,调用drawPlaceholderInRect:方法实现
     
     // 方法4,利用运行时的实现原理,获取输入框中占位符的属性名，从而给其赋值
     UILabel *label = [self valueForKeyPath:@"placeholderLabel"];
     label.textColor = [UIColor grayColor];
     // 或
     [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
     */
}

/**
 *  方法3,调用drawPlaceholderInRect:方法实现
 */
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
//    attrs[NSFontAttributeName] = self.font;
//    
//    // 方式一
//    CGRect bounds = self.bounds;
//    bounds.origin.y = (self.height - self.font.lineHeight) * 0.5;
//    
//    [self.placeholder drawInRect:bounds withAttributes:attrs];
//    
//    // 方式二
//    CGPoint point;
//    point.x = 0;
//    point.y = (self.height - self.font.lineHeight) * 0.5;
//    
//    [self.placeholder drawAtPoint:point withAttributes:attrs];
//}

@end
