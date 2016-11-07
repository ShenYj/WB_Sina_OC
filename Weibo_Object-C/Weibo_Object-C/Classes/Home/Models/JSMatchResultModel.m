//
//  JSMatchResultModel.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/7.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSMatchResultModel.h"

@implementation JSMatchResultModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)resultWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithResult:(NSString *)result withRange:(NSRange)range {
    self = [super init];
    if (self) {
        
        self.result = result;
        self.range = range;
    }    
    return self;
}

@end
