//
//  JSNetworkTool.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/6/30.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSNetworkTool.h"

@implementation JSNetworkTool

+ (instancetype)sharedNetworkTool{
    
    static JSNetworkTool *_instanceType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[JSNetworkTool alloc]init];
    });
    return _instanceType;
}

- (void)requestWithMethod:(NSString *)requestMethod withParameters:(NSDictionary *)parametes withUrlString:(NSString *)urlString withSuccess:(void (^)(id obj))success withError:(void (^)(NSError *error))failure{
    
    if ([requestMethod isEqualToString:@"GET"]) {
        
        [[JSNetworkTool sharedNetworkTool] GET:urlString parameters:parametes progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
            
        }];
        
    }else{
        
        [[JSNetworkTool sharedNetworkTool] POST:urlString parameters:parametes progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
            
        }];
    }
    
}











@end
