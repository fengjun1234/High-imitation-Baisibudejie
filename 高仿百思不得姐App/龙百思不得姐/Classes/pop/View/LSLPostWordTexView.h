//
//  LSLPostWordTexView.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/12.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLPostWordTexView : UITextView
/** 占位文字 */
@property(nonatomic,copy)NSString *placeholder;
/** 占位文字颜色 */
@property(nonatomic,strong)UIColor *placeholderColor;

@end
