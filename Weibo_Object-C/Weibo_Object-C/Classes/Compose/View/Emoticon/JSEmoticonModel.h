//
//  JSEmoticonModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/2.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSEmoticonModel : NSObject


/**
 *   0  -> 图片表情; 1-->  emoji表情
 */
@property (copy,nonatomic) NSString *type;

#pragma mark - Emoji
@property (copy,nonatomic) NSString *code;

#pragma mark - 浪小花
@property (copy,nonatomic) NSString *chs;
@property (copy,nonatomic) NSString *png;


#pragma mark - default



- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)emoticonWithDict:(NSDictionary *)dict;


@end
