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


#pragma mark
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

#pragma mark - public content
- (void)loadHomePublicDatawithFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock {
    
    /*
     
     access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     count	false	int	单页返回的记录条数，最大不超过100，默认为20。
     page	false	int	返回结果的页码，默认为1。
     base_app	false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
     feature	false	int	过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
     trim_user	false	int	返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
     
     */
    NSString *urlString = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSDictionary *para = @{
                           @"access_token": [JSUserAccountTool sharedManager].access_token
                           //@"since_id": @0,
                           //@"max_id": @0,
                           };
    
    [self requestWithMethod:RequestMethodGet withParameters:para withUrlString:urlString withSuccess:^(id obj) {
        
        NSArray *statuses = [obj objectForKey:@"statuses"];
        NSLog(@"%@",statuses);
        
        finishedBlock(obj,nil);
        
    } withError:^(NSError *error) {
        
        finishedBlock(nil,error);
        
    }];
    
}


@end
