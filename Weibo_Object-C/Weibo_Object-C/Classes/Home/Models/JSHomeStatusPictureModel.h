//
//  JSHomeStatusPictureModel.h
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/23.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSHomeStatusPictureModel : NSObject

// 配图地址
@property (nonatomic,copy) NSString *thumbnail_pic;


+ (instancetype)picWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
