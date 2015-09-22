//
//  LSLAddTagViewController.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/12.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLAddTagViewController : UIViewController
/** 传递数据block */
@property(nonatomic,copy)void (^tagsBlock) (NSArray *);
/** 已有的标签 */
@property(nonatomic,strong)NSArray *tags;
@end
