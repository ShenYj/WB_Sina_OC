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

#pragma mark
#pragma mark - properties
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
// 转发微博
@property (nonatomic) JSHomeStatusModel *retweeted_status;
// 转发数
@property (nonatomic) NSNumber *reposts_count;
// 评论数
@property (nonatomic) NSNumber *comments_count;
// 表态数
@property (nonatomic) NSNumber *attitudes_count;

#pragma mark - 自定义属性 (底部ToolBar的数据,将数值类型转换成字符串并保存起来)
@property (nonatomic,copy) NSString *reposts_count_string;
@property (nonatomic,copy) NSString *comments_count_string;
@property (nonatomic,copy) NSString *attitudes_count_string;

#pragma mark
#pragma mark - methods
// 静态方法
+ (instancetype)statuWithDict:(NSDictionary *)dict;
// 实例方法
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
