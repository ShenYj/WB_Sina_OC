//
//  JSHomeStatusUserModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UserStatus) {
    UserStatusOnline,
    UserStatusOffline
};

@interface JSHomeStatusUserModel : NSObject

// 用户id
@property (nonatomic) NSNumber *user_id;
// 用户昵称
@property (nonatomic,copy) NSString *name;
// 用户头像
@property (nonatomic,copy) NSString *profile_image_url;
// 认证类型 -1:没有认证,0:认证用户,2.3.5:企业认证, 220:达人
@property (nonatomic) NSNumber *verified_type;
// 用户的在线状态，0：不在线、1：在线
@property (nonatomic) NSNumber *online_status;

#pragma mark - 自定义Key
// 用户在线状态 (自定义Key)
@property (nonatomic,assign) UserStatus userstatus;


#pragma mark - method
// 实例方法
- (instancetype)initWithDict:(NSDictionary *)dict;
// 静态方法
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
