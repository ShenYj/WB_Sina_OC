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
