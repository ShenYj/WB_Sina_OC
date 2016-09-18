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
        _instanceType.responseSerializer.acceptableContentTypes = [_instanceType.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    });
    return _instanceType;
}

#pragma mark - Public

- (void)requestWithMethod:(RequestMethod)requestMethod withParameters:(NSDictionary *)parametes withUrlString:(NSString *)urlString withSuccess:(void (^)(id obj))success withError:(void (^)(NSError *error))failure{
    
    if (requestMethod == RequestMethodGet) {
        
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



#pragma mark - Load access_token
- (void)loadAccessTokenWithCode:(NSString *)code withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock {
    
    NSDictionary *para = @{
                           @"client_id":@"3071143364",
                           @"client_secret":@"dc2478f9204b2551d8ff7dba427d576e",
                           @"grant_type":@"authorization_code",
                           @"code":code,
                           @"redirect_uri":@"http://www.jianshu.com/users/5ec5747435a2/latest_articles"
                           };
    
    NSString *urlString = @"https://api.weibo.com/oauth2/access_token";
    
    [self requestWithMethod:RequestMethodPost withParameters:para withUrlString:urlString withSuccess:^(id obj) {
        finishedBlock(obj,nil);
    } withError:^(NSError *error) {
        finishedBlock(nil,error);
    }];
}


#pragma mark - Load User Info
- (void)loadUserAccountInfo:(JSUserAccountModel *)userAccountModel withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock {
    
    NSDictionary *para = @{
                           @"access_token":userAccountModel.access_token,
                           @"uid":userAccountModel.uid
                           };
    
    NSString *urlString = @"https://api.weibo.com/2/users/show.json";
    
    [self requestWithMethod:RequestMethodGet withParameters:para withUrlString:urlString withSuccess:^(id obj) {
        finishedBlock(obj,nil);
    } withError:^(NSError *error) {
        finishedBlock(nil,error);
    }];
    
}


@end
