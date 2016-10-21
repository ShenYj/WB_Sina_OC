//
//  JSHomeStatusModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSHomeStatusModel : NSObject

// 微博创建时间
@property (nonatomic,copy) NSString *created_at;
// 微博ID
@property (nonatomic) NSNumber *wb_id;
// 微博信息内容
@property (nonatomic,copy) NSString *text;
// 微博来源
@property (nonatomic,copy) NSString *source;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)statuWithDict:(NSDictionary *)dict;

@end
