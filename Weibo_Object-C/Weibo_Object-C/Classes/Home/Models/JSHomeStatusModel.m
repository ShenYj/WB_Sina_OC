
//
//  JSHomeStatusModel.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeStatusModel.h"

@implementation JSHomeStatusModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)statuWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        NSLog(@"%@",[value class]);
        
    } else {
        
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (NSString *)description {
    
    NSArray *keys = [JSHomeStatusModel js_objProperties];
    
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
