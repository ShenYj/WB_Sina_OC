//
//  JSUserAccountModel.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/9/18.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSUserAccountModel.h"

@implementation JSUserAccountModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_uid forKey:@"uid"];
    [aCoder encodeObject:_screen_name forKey:@"screen_name"];
    [aCoder encodeObject:_avatar_large forKey:@"avatar_large"];
    [aCoder encodeObject:_expires_Date forKey:@"expires_date"];
    [aCoder encodeObject:_access_token forKey:@"access_token"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        _uid = [aDecoder decodeObjectForKey:@"uid"];
        _screen_name = [aDecoder decodeObjectForKey:@"uiscreen_named"];
        _access_token = [aDecoder decodeObjectForKey:@"access_token"];
        _expires_Date = [aDecoder decodeObjectForKey:@"expires_Date"];
        _avatar_large = [aDecoder decodeObjectForKey:@"avatar_large"];
    }
    return self;
}

- (NSString *)description {
    
    NSArray *keys = [JSUserAccountModel js_objProperties];
    
    return [self dictionaryWithValuesForKeys:keys].description;
}

- (void)setExpires_in:(NSTimeInterval)expires_in {
    
    _expires_in = expires_in;
    
    _expires_Date = [NSDate dateWithTimeIntervalSinceNow:expires_in];
    
}

@end
