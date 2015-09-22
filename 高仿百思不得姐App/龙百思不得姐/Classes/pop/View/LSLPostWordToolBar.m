//
//  LSLPostWordToolBar.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/12.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLPostWordToolBar.h"
#import "LSLAddTagViewController.h"
#import "LSLNavigationController.h"

@interface LSLPostWordToolBar()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/** 标签label集合 */
@property(nonatomic,strong)NSMutableArray *tagLabels;
/** 添加标签add按钮 */
@property(nonatomic,strong)UIButton *addBtn;
@end

@implementation LSLPostWordToolBar

#pragma mark - 懒加载
- (NSMutableArray *)tagLabels
{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return  _tagLabels;
}

- (void)awakeFromNib
{
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [addBtn sizeToFit];
    // 添加监听事件
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:addBtn];
    self.addBtn = addBtn;
    
    // 调整工具栏的高度
    [self setupToolHeight];
    
    // 默认标签
    [self createTagLabels:@[@"吐槽",@"糗事"]];
}

/**
 *  规律:
 *  A --model--> B
 *  A.presentedViewController == B
 *  B.presentingViewController == A
 */
- (void)addClick
{
    // 创建添加标签窗口
    LSLAddTagViewController *addTagVC = [[LSLAddTagViewController alloc] init];
    
    UIViewController *vc =  self.window.rootViewController.presentedViewController;
    
    [vc presentViewController:[[LSLNavigationController alloc] initWithRootViewController:addTagVC] animated:YES completion:nil];
    
    addTagVC.tagsBlock = ^(NSArray *tags){
        // 布局标签子控件
        [self createTagLabels:tags];
    };
    
    // 添加标签
    addTagVC.tags = [self.tagLabels valueForKeyPath:@"text"];
}

#pragma mark - 创建标签子控件
- (void)createTagLabels:(NSArray *)tags
{
    // 方法2：让self.tagLabels数组中的所有对象执行removeFromSuperview方法
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    // 创建标签label并布局
    for (int i = 0; i < tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.text = tags[i];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.font = [UIFont systemFontOfSize:14];
        tagLabel.backgroundColor = LSLTagBtnBGColor;
        
        [tagLabel sizeToFit];
        tagLabel.height = LSLTagHeight;
        tagLabel.width += 2 * LSLCommonSmallMargin;
        
        [self.topView addSubview:tagLabel];
        
        // 添加到标签label数组中
        [self.tagLabels addObject:tagLabel];
    }
    
    // 创建完成后，重新布局子控件
    [self setNeedsLayout];
}

#pragma mark - layoutSubviews方法布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];

    // 创建标签label并布局
    for (int i = 0; i < self.tagLabels.count; i++) {
        UILabel *tagLabel = self.tagLabels[i];
        
        // 布局
        if (i == 0) { // 第一个标签label
            tagLabel.x = 0;
            tagLabel.y = 0;
        }else{ // 不是第一个标签label
            // 最后一个标签label加间距的长度
            UILabel *previousTagLabel = self.tagLabels[i - 1];
            
            CGFloat leftWidth = CGRectGetMaxX(previousTagLabel.frame) + LSLCommonSmallMargin;
            // 右边剩余的长度
            CGFloat rightWidth = self.topView.width - leftWidth;
            
            if (rightWidth >= tagLabel.width) { // 跟上一个标签同一行
                tagLabel.x = leftWidth;
                tagLabel.y = previousTagLabel.y;
            }else{  // 换行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(previousTagLabel.frame) + LSLCommonSmallMargin;
            }
        }
    }
    
    // 布局加号按钮
    // 最后一个标签label加间距的长度
    UILabel *lastTagLabel = self.tagLabels.lastObject;
    if (!lastTagLabel) { // 第一个标签label
        self.addBtn.x = 0;
        self.addBtn.y = 0;
    }else{ // 不是第一个标签label
        CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + LSLCommonSmallMargin;
        // 右边剩余的长度
        CGFloat rightWidth = self.topView.width - leftWidth;
        
        if (rightWidth >= self.addBtn.width) { // 跟上一个标签同一行
            self.addBtn.x = leftWidth;
            self.addBtn.y = lastTagLabel.y;
        }else{  // 换行
            self.addBtn.x = 0;
            self.addBtn.y = CGRectGetMaxY(lastTagLabel.frame) + LSLCommonSmallMargin;
        }
    }
    
    // 调整工具栏的高度
    [self setupToolHeight];
}

#pragma mark - 调整工具栏的高度
- (void)setupToolHeight
{
    CGFloat oldHeight = self.height;
    self.height = CGRectGetMaxY(self.addBtn.frame) + LSLCommonMargin + self.bottomView.height;
    self.y -= self.height - oldHeight;
}

@end
