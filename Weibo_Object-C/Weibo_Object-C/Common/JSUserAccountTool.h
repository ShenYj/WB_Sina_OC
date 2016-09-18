//
//  JSUserAccountModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/9/11.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSUserAccountModel.h"

@interface JSUserAccountTool : NSObject


/**
 判断用户是否登录的标识
 */
@property (nonatomic,assign,getter=isLogin) BOOL login;
/**
 用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别
 */
@property (nonatomic,copy) NSString *access_token;

/**
 用户信息对象
 */
@property (nonatomic,strong) JSUserAccountModel *userAccountModel;
/**
 *  单例方法
 *
 *  @return 单例对象
 */
+ (instancetype)sharedManager;

/**
 保存用户信息

 @param userAccountModel 用户信息对象
 */
- (void)saveUserAccount:(JSUserAccountModel *)userAccountModel;

/**
 获取用户信息

 @return 用户信息对象
 */
- (JSUserAccountModel *)getUerAccount;

@end
