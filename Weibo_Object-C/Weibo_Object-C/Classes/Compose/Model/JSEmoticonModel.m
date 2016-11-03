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

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (NSString *)description {
    
    NSArray *keys = [JSEmoticonModel js_objProperties];
    return [self dictionaryWithValuesForKeys:keys].description;
}

- (void)setType:(NSString *)type {
    
    _type = type;
    if ([type isEqualToString:@"0"]) {
        self.emoji = NO;
    } else {
        self.emoji = YES;
    }
}

@end
