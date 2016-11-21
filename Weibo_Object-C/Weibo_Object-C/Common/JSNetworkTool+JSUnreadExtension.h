//
//  JSNetworkTool+JSNetworkNoticeExtension.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSNetworkTool.h"

/** 负责请求微博未读信息相关处理 */

@interface JSNetworkTool (JSUnreadExtension)

// 请求微博未读数
- (void)loadUnreadStatusCountsWithCompeletionHandler:(void (^)(NSInteger count))compeletionHandler;

@end
