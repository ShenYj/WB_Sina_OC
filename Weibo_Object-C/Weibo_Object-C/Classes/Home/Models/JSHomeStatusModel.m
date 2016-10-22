
//
//  JSHomeStatusModel.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeStatusModel.h"
#import "JSHomeStatusUserModel.h"


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
        
        self.wb_id = value;
        
    } else if ([key isEqualToString:@"user"]) {
        
        NSDictionary *dict = (NSDictionary *)value;
        
        JSHomeStatusUserModel *userModel = [JSHomeStatusUserModel modelWithDict:dict];
        
        self.user = userModel;
        
    } else if ([key isEqualToString:@"retweeted_status"]) {
        
        NSDictionary *dict = (NSDictionary *)value;
        
        JSHomeStatusModel *retweeted_status = [JSHomeStatusModel statuWithDict:dict];
        
        self.retweeted_status = retweeted_status;
        
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
