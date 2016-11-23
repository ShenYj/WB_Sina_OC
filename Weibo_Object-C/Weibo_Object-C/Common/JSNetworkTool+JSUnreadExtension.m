//
//  JSNetworkTool+JSNetworkNoticeExtension.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSNetworkTool+JSUnreadExtension.h"
#import "JSUserAccountTool.h"

@implementation JSNetworkTool (JSUnreadExtension)


#pragma mark
#pragma mark - Load access_token
- (void)loadAccessTokenWithCode:(NSString *)code
              withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock {
    
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
- (void)loadUserAccountInfo:(JSUserAccountModel *)userAccountModel
          withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock {
    
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
- (void)loadHomePublicDatawithFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock
                                   Since_id:(NSInteger)since_id
                                     max_id:(NSInteger)max_id {
    
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
    if (![JSUserAccountTool sharedManager].access_token) return;
    
    NSString *urlString = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSDictionary *para = @{
                           @"access_token": [JSUserAccountTool sharedManager].access_token,
                           @"since_id": @(since_id),
                           @"max_id": @(max_id)
                           };
    
    [self requestWithMethod:RequestMethodGet withParameters:para withUrlString:urlString withSuccess:^(id obj) {
        
        NSArray <NSDictionary *>*statuses = [obj objectForKey:@"statuses"];
        
        finishedBlock(statuses,nil);
        
    } withError:^(NSError *error) {
        
        finishedBlock(nil,error);
        
    }];
    
}

#pragma mark - 发送文字微博
- (void)composeStatus:(NSString *)status
    withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock {
    
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
- (void)composeStatusWithPictures:(NSDictionary *)contents
                withFinishedBlock:(void (^)(id, NSError *))finishedBlock {
    
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

// 请求首页数据
- (void)loadHomeStatusCompeletionHandler:(void (^)(NSArray *, BOOL))compeletionHandler {
    
    
    NSString *urlString = @"https://api.weibo.com/2/statuses/home_timeline.json";
    
    [self accessTokenRequestMetohd:RequestMethodGet parameters:nil urlString:urlString CompeletionHandler:^(id obj, BOOL isSuccess) {
        NSArray <NSDictionary *>*statuses = [obj objectForKey:@"statuses"];
        
        compeletionHandler(statuses,isSuccess);
    }];
    
}


- (void)loadUnreadStatusCountsWithCompeletionHandler:(void (^)(NSInteger))compeletionHandler {
    
    /*
     access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     uid	true	int64	需要获取消息未读数的用户UID，必须是当前登录用户。
     callback	false	string	JSONP回调函数，用于前端调用返回JS格式的信息。
     unread_message	false	boolean	未读数版本。0：原版未读数，1：新版未读数。默认为0。
     */
    NSString *urlString = @"https://rm.api.weibo.com/2/remind/unread_count.json";
    NSDictionary *para = @{
                           @"access_token": [JSUserAccountTool sharedManager].access_token,
                           @"uid" : [JSUserAccountTool sharedManager].userAccountModel.uid,
                           @"unread_message": @0
                           };
    
    [self requestWithMethod:RequestMethodGet withParameters:para withUrlString:urlString withSuccess:^(id obj) {
        
        NSDictionary *unReadDict = (NSDictionary *)obj;
        compeletionHandler([unReadDict[@"status"] integerValue]);
        
    } withError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    /*
     
         status	int	新微博未读数
         follower	int	新粉丝数
         cmt	int	新评论数
         dm	int	新私信数
         mention_status	int	新提及我的微博数
         mention_cmt	int	新提及我的评论数
         group	int	微群消息未读数
         private_group	int	私有微群消息未读数
         notice	int	新通知未读数
         invite	int	新邀请未读数
         badge	int	新勋章数
         photo	int	相册消息未读数
         msgbox	int	{{{3}}}
     */
}

@end
