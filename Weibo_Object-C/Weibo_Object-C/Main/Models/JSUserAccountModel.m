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
    
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.screen_name forKey:@"screen_name"];
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.expires_Date forKey:@"expires_date"];
    [aCoder encodeObject:self.avatar_large forKey:@"avatar_large"];
    [aCoder encodeInteger:self.expiredCycle forKey:@"expiredCycle"];
    
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.screen_name = [aDecoder decodeObjectForKey:@"screen_name"];
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_Date = [aDecoder decodeObjectForKey:@"expires_date"];
        self.avatar_large = [aDecoder decodeObjectForKey:@"avatar_large"];
        self.expiredCycle = [aDecoder decodeIntegerForKey:@"expiredCycle"];
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
