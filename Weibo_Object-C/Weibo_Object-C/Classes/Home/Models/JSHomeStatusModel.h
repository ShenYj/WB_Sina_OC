//
//  JSHomeStatusModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSHomeStatusModel;
@class JSHomeStatusUserModel;

@interface JSHomeStatusModel : NSObject

// 微博创建时间
@property (nonatomic,copy) NSString *created_at;
// 微博ID
@property (nonatomic) NSNumber *wb_id;
// 微博信息内容
@property (nonatomic,copy) NSString *text;
// 微博来源
@property (nonatomic,copy) NSString *source;
// 微博作者的用户信息字段
@property (nonatomic) JSHomeStatusUserModel *user;

// 实例方法
- (instancetype)initWithDict:(NSDictionary *)dict;
// 静态方法
+ (instancetype)statuWithDict:(NSDictionary *)dict;


@end
