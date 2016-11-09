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
 *查询本地数据
 */
+ (NSArray <JSHomeStatusModel *>*)getLocalCacheWithSinceid:(NSInteger)sinceId withMaxId:(NSInteger)maxId;

@end
