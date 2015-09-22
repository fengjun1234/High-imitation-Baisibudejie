//
//  LSLHeaderFooterView.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/18.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLHeaderFooterView.h"

@interface LSLHeaderFooterView()
/** 内部标签 */
@property(nonatomic,weak)UILabel *label;
@end

@implementation LSLHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = LSLCommenBGColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = LSLGrayColor(80);
        label.font = [UIFont systemFontOfSize:15];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.x = LSLCommonMargin;
        
        self.label = label;
        [self.contentView addSubview:label];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    self.label.text = text;
}

@end
