//
//  JSSQLDAL.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/9.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>


@class JSHomeStatusModel;

@interface JSSQLDAL : NSObject

/**
 * 保存数据
 */
+ (void)saveCache:(NSArray <NSDictionary *>*)status;

/**
 * 查询本地数据
 */
+ (NSArray <JSHomeStatusModel *>*)getLocalCacheWithSinceid:(NSInteger)sinceId withMaxId:(NSInteger)maxId;

/**
 * 检查本地是否有缓存数据,若没有,请求网络数据,有则加载本地数据
 */
+ (void)checkLocalCacheWithSinceid:(NSInteger)sinceId withMaxid:(NSInteger)maxId withFinishedBlock:(void (^)(id obj, NSError *error))finishedBlock;

/**
 * 清除缓存,(默认时间一周)
 */
+ (void)deleteCache;

@end
