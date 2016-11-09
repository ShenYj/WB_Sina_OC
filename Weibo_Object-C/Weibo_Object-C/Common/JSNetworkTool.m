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
        
        [self GET:urlString parameters:parametes progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
            
        }];
        
    }else{
        
        [self POST:urlString parameters:parametes progress:^(NSProgress * _Nonnull uploadProgress) {
            
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
- (void)loadHomePublicDatawithFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock Since_id:(NSInteger)since_id max_id:(NSInteger)max_id {
    
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
                           @"access_token": [JSUserAccountTool sharedManager].access_token,
                           @"since_id": @(since_id),
                           @"max_id": @(max_id)
                           };
    
    [self requestWithMethod:RequestMethodGet withParameters:para withUrlString:urlString withSuccess:^(id obj) {
        
        NSArray *statuses = [obj objectForKey:@"statuses"];
        
        finishedBlock(statuses,nil);
        
    } withError:^(NSError *error) {
        
        finishedBlock(nil,error);
        
    }];
    
}

#pragma mark - 发送文字微博
- (void)composeStatus:(NSString *)status withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock {
    
    NSString *urlString = @"https://api.weibo.com/2/statuses/update.json";
    NSDictionary *paras = @{
                            @"access_token": [JSUserAccountTool sharedManager].access_token,
                            @"status":status,
                            };
    
    [self requestWithMethod:RequestMethodPost withParameters:paras withUrlString:urlString withSuccess:^(id obj) {
        
        finishedBlock(obj,nil);
        
    } withError:^(NSError *error) {
        
        finishedBlock(nil,error);
    }];
    
}

#pragma mark - 发送文字&图片微博
- (void)composeStatusWithPictures:(NSDictionary *)contents withFinishedBlock:(void (^)(id, NSError *))finishedBlock {
    
    NSString *urlString = @"https://upload.api.weibo.com/2/statuses/upload.json";
    NSDictionary *paras = @{
                            @"access_token": [JSUserAccountTool sharedManager].access_token,
                            @"status": contents[@"status"]
                            };
    
    [self POST:urlString parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSArray *images = (NSArray <UIImage *>*)contents[@"pics"];
        // 遍历配图数组
        for (UIImage *image in images) {
            // 转成二进制
            NSData *imageData = UIImagePNGRepresentation(image);
            // 新浪微博中,服务器会为图片进行名称处理,即便指定也无意义
            [formData appendPartWithFileData:imageData name:@"pic" fileName:@"image.jpg" mimeType:@"application/octet-stream"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedBlock(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finishedBlock(nil,error);
    }];
     
}

@end
