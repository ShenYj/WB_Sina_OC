//
//  JSUserAccountModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 16/9/11.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSUserAccountToolModel : NSObject

/**
 *  调用authorize获得的code值
 */
@property (nonatomic,copy) NSString *code;





/**
 *  单例方法
 *
 *  @return 单例对象
 */
+ (instancetype)sharedManager;

/**
 *  字典转模型实例方法
 *
 *  @param dict 需要转换成模型的字典
 *
 *  @return 转换后的模型对象
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
/**
 *  类方法
 *
 *  @param dict 需要转换成模型的字典
 *
 *  @return 转换后的模型对象
 */
+ (instancetype)userAccountToolModelWithDict:(NSDictionary *)dict;

@end
