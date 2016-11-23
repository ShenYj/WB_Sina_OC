//
//  JSNetworkTool.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/30.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSNetworkTool.h"
#import "JSUserAccountTool.h"


@implementation JSNetworkTool

+ (instancetype)sharedNetworkTool{
    
    static JSNetworkTool *_instanceType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instanceType = [[JSNetworkTool alloc]init];
        _instanceType.responseSerializer.acceptableContentTypes = [_instanceType.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain",@"text/html",@"application/json"]];
        //_instanceType.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return _instanceType;
}


#pragma mark
#pragma mark - 基于AccessToken的二次封装

- (void)accessTokenRequestMetohd:(RequestMethod)requestMethod
                      parameters:(NSDictionary *)parameters
                       urlString:(NSString *)urlString
              CompeletionHandler:(void (^)(id obj, BOOL isSuccess))compeletionHandler {
    
    if (![JSUserAccountTool sharedManager].isLogin) {
        NSLog(@"AccessToken 过期");
        compeletionHandler(nil,NO);
        return;
    }
    
    NSMutableDictionary *mParas = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mParas setObject:[JSUserAccountTool sharedManager].access_token forKey:@"access_token"];
    
    [self requestWithMethod:requestMethod withParameters:mParas withUrlString:urlString withSuccess:^(id obj) {
        
        compeletionHandler(obj,YES);
        
    } withError:^(NSError *error) {
        
        compeletionHandler (nil,NO);
    }];
}

#pragma mark
#pragma mark - Public

- (void)requestWithMethod:(RequestMethod)requestMethod
           withParameters:(NSDictionary *)parametes
            withUrlString:(NSString *)urlString
              withSuccess:(void (^)(id obj))success
                withError:(void (^)(NSError *error))failure {
    
    if (requestMethod == RequestMethodGet) {
        
        [self GET:urlString parameters:parametes progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
            if (urlResponse.statusCode == 403) {
                NSLog(@"Token过期");
                
                // 发送通知 切换到登录视图
                
            }
            
            failure(error);
            
        }];
        
    } else {
        
        [self POST:urlString parameters:parametes progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
            
        }];
    }
    
}




@end
