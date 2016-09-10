//
//  JSNetworkTool.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/30.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface JSNetworkTool : AFHTTPSessionManager

+ (instancetype)sharedNetworkTool;
- (void)requestWithMethod:(NSString *)requestMethod withParameters:(NSDictionary *)parametes withUrlString:(NSString *)urlString withSuccess:(void (^)(id obj))success withError:(void (^)(NSError *error))failure;

@end
