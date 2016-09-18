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

@end
