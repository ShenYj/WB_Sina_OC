//
//  JSUserAccountModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/9/18.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSUserAccountModel : NSObject <NSCoding>



/**
 授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据
 */
@property (nonatomic,copy) NSString *uid;
/**
 用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别
 */
@property (nonatomic,copy) NSString *access_token;
/**
 access_token的生命周期（该参数即将废弃，开发者请使用expires_in
 */
@property (nonatomic,copy) NSString *remind_in;
/**
 access_token的生命周期，单位是秒数
 */
@property (nonatomic,copy) NSString *expires_in;

/**
 过期日期
 */
@property (nonatomic,copy) NSString *expires_Date;
/**
 用户头像
 */
@property (nonatomic,copy) NSString *avatar_large;
/**
 用户昵称
 */
@property (nonatomic,copy) NSString *screen_name;

@end
