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
    [aCoder encodeObject:self.avatar_large forKey:@"avatar_large"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.expires_Date forKey:@"expires_Date"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.screen_name = [aDecoder decodeObjectForKey:@"uiscreen_named"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.expires_Date = [aDecoder decodeObjectForKey:@"expires_Date"];
        self.avatar_large = [aDecoder decodeObjectForKey:@"avatar_large"];
    }
    return self;
}


@end
