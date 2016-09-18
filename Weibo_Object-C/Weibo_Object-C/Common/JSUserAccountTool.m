//
//  JSUserAccountModel.m
//  Weibo_Object-C
//
//  Created by ShenYj on 16/9/11.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSUserAccountTool.h"

static JSUserAccountTool *_instanceType = nil;

@implementation JSUserAccountTool


+ (instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[self alloc] init];
    });
    return _instanceType;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userAccountModel = [self getUerAccount];
    }
    return self;
}

- (void)saveUserAccount:(JSUserAccountModel *)userAccountModel {
    
    self.userAccountModel = userAccountModel;
    
    // 归档
    [NSKeyedArchiver archiveRootObject:userAccountModel toFile:[self getDocumentDirectoryPath]];
}

- (JSUserAccountModel *)getUerAccount {
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getDocumentDirectoryPath]];
}

- (NSString *)getDocumentDirectoryPath {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userAccount.archiver"];
}

- (NSString *)description {
    
    NSArray *keys = [JSUserAccountTool js_objProperties];
    return [[self dictionaryWithValuesForKeys:keys] description];
}

@end
