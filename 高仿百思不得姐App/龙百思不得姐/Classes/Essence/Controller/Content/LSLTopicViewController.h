//
//  LSLTopicViewController.h
//  龙百思不得姐
//
//  Created by lisilong on 15/9/20.
//  Copyright © 2015年 longshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSLTopic.h"

@interface LSLTopicViewController : UITableViewController
/** 帖子类型 */
- (LSLTopicType)type;
//@property(nonatomic,assign)LSLTopicType type;
@end
