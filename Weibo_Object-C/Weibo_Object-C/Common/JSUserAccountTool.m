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
        // 实例化的时候就从本地获取数据
        self.userAccountModel = [self getUerAccount];
    }
    return self;
}

- (void)saveUserAccount:(JSUserAccountModel *)userAccountModel {
    
    // 首次启动创建单例对象,在未重启的情况下,单例对象已经存在,当一请求获取到信息的时候,手动给自己的userAccountModel属性进行赋值
    self.userAccountModel = userAccountModel;
    
    // 归档
    [NSKeyedArchiver archiveRootObject:userAccountModel toFile:[self getDocumentDirectoryPath]];
}

- (JSUserAccountModel *)getUerAccount {
    // 解档
    //JSUserAccountModel *userAccountModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getDocumentDirectoryPath]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getDocumentDirectoryPath]];
}

- (NSString *)getDocumentDirectoryPath {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userAccount.archiver"];
}

- (NSString *)description {
    
    NSArray *keys = [JSUserAccountTool js_objProperties];
    return [[self dictionaryWithValuesForKeys:keys] description];
    
}

- (NSString *)access_token {
    
    if (self.userAccountModel.access_token == nil) {
        return nil;
    } else {
        
        // 已登录
        if ( [self.userAccountModel.expires_Date compare:[NSDate date]] == NSOrderedDescending ) {
            return self.userAccountModel.access_token;
        } else {
            // 清除数据
            [[NSFileManager defaultManager] removeItemAtPath:[self getDocumentDirectoryPath] error:NULL];
            return nil;
        }
    }
}

- (NSString *)kChangeRootViewControllerNotification {
    return @"changeRootViewControllerNotification";
}

- (BOOL)isLogin {
    return self.access_token != nil;
}

@end
