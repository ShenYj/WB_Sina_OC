//
//  JSEmoticonModel.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/2.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSEmoticonModel.h"

@implementation JSEmoticonModel


- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)emoticonWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}



@end
