//
//  LSLMJExtension.m
//  龙百思不得姐
//
//  Created by lisilong on 15/9/18.
//  Copyright (c) 2015年 longshao. All rights reserved.
//

#import "MJExtensionConfig.h"
#import <MJExtension/MJExtension.h>
#import "LSLTopic.h"
#import "LSLUser.h"
#import "LSLComment.h"
#import "LSLCategory.h"

@implementation MJExtensionConfig

+ (void)load
{
    [LSLTopic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"hotComent" : @"top_cmt[0]",
                 };
    }];

    [LSLComment setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    
    // 只需要在字典转模型之前, 告诉框架要将模型中的哪个属性和字典中的哪个KEY对应
    [LSLCategory setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"categoryID":@"id"};
    }];
    
}
@end
