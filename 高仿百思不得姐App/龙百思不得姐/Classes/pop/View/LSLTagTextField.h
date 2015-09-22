//
//  LSLTagTextField.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/13.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLTagTextField : UITextField
/** 点击返回删除按钮需要执行的操作 */
@property(nonatomic,copy) void (^deleteBackwardOperation)();
@end
