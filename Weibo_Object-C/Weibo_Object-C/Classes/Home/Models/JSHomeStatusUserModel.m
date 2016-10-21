//
//  JSHomeStatusUserModel.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/10/21.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSHomeStatusUserModel.h"

@implementation JSHomeStatusUserModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    
    return [[self alloc]initWithDict:dict];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"user_id"]) {
        
        self.user_id = value;
        
    } else {
        
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (NSString *)description {
    
    NSArray *keys = [JSHomeStatusUserModel js_objProperties];
    
    return [self dictionaryWithValuesForKeys:keys].description;
}

- (UserStatus)userstatus {
    
    if (self.online_status.intValue == 0) {
        
        return UserStatusOffline;
    } else {
        
        return UserStatusOnline;
    }
    
}

@end
