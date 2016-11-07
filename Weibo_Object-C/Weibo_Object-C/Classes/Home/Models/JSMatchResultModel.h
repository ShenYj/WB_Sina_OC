//
//  JSMatchResultModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/7.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSMatchResultModel : NSObject

// 匹配到的结果
@property (nonatomic,copy) NSString *result;
// 匹配结果的区间
@property (nonatomic) NSRange range;

- (instancetype)initWithResult:(NSString *)result withRange:(NSRange)range;

//- (instancetype)initWithDict:(NSDictionary *)dict;
//+ (instancetype)resultWithDict:(NSDictionary *)dict;

@end
