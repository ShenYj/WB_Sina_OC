//
//  JSNetworkTool.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/30.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "JSUserAccountModel.h"

typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGet,
    RequestMethodPost
};

@interface JSNetworkTool : AFHTTPSessionManager

+ (instancetype)sharedNetworkTool;

/** 公共方法 基于AccessToken的二次封装 */
- (void)accessTokenRequestMetohd:(RequestMethod)requestMethod
                      parameters:(NSDictionary *)parameters
                       urlString:(NSString *)urlString
              CompeletionHandler:(void (^)(id obj, BOOL isSuccess))compeletionHandler;

/**
 公共方法

 @param requestMethod 请求方法
 @param parametes     参数
 @param urlString     URL连接
 @param success       成功回调
 @param failure       失败回调
 */
- (void)requestWithMethod:(RequestMethod)requestMethod
           withParameters:(NSDictionary *)parametes
            withUrlString:(NSString *)urlString
              withSuccess:(void (^)(id obj))success
                withError:(void (^)(NSError *error))failure;





@end
