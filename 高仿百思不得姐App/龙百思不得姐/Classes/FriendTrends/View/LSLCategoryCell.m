//
//  LSLCategoryCell.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/8.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLCategoryCell.h"
#import "LSLCategory.h"

@interface LSLCategoryCell()
/** 选中时显示的指示器view */
@property (weak, nonatomic) IBOutlet UIView *selectedCategoryView;
@end
@implementation LSLCategoryCell

- (void)awakeFromNib {
    // cell背景颜色
    self.backgroundColor = LSLARGBColor(255, 244, 244, 244);
    
    // 选中时显示的指示器view的背景颜色
    self.selectedCategoryView.backgroundColor = LSLARGBColor(255, 190, 19, 9);
}

- (void)setCategory:(LSLCategory *)category
{
    _category = category;
    
    // 设置显示数据
    self.textLabel.text = category.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.y = 2;
    self.textLabel.height = self.height - 2 * self.textLabel.y;
}

/**
 *  当cell的selection为None时, cell被选中时, 内部的子控件就不会进入高亮状态
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // 选中时显示指示器view
    self.selectedCategoryView.hidden = !selected;
    
    // 选中时，修改一些cell的标题属性
    self.textLabel.textColor = selected ? LSLARGBColor(255, 190, 19, 9): LSLARGBColor(255, 79, 79, 79);
}

@end
