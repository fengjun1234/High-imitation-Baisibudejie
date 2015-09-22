//
//  LSLTitleButton.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/13.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "LSLTitleButton.h"

@implementation LSLTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{

}
@end
