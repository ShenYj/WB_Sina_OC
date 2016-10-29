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

/**
 公共方法

 @param requestMethod 请求方法
 @param parametes     参数
 @param urlString     URL连接
 @param success       成功回调
 @param failure       失败回调
 */
- (void)requestWithMethod:(RequestMethod)requestMethod withParameters:(NSDictionary *)parametes withUrlString:(NSString *)urlString withSuccess:(void (^)(id obj))success withError:(void (^)(NSError *error))failure;


/**
 获取Access Token

 @param code          调用authorize获得的code值
 @param finishedBlock 完成回调
 */
- (void)loadAccessTokenWithCode:(NSString *)code withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock;


/**
 获取用户信息

 @param userAccountModel 用户信息对象
 */
- (void)loadUserAccountInfo:(JSUserAccountModel *)userAccountModel withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock;

/**
 获取当前登录用户及其所关注（授权）用户的最新微博
 @param Since_id      下拉时指定此参数
 @param max_id        上拉时指定此参数
 @param finishedBlock 完成回调
 */
- (void)loadHomePublicDatawithFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock Since_id:(NSInteger)since_id max_id:(NSInteger)max_id;
//- (void)loadHomePublicDatawithFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock;


/**
 发布文字文博
 @param status        文字微博
 @param finishedBlock 完成回调
 */
- (void)composeStatus:(NSString *)status withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock;




@end
