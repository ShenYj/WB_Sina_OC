//
//  JSSQLManager.m
//  Weibo_Object-C
//
//  Created by ShenYj on 2016/11/8.
//  Copyright © 2016年 ___ShenYJ___. All rights reserved.
//

#import "JSSQLManager.h"

static JSSQLManager *_instanceType = nil;
static NSString * const databasePath = @"database.db";

@implementation JSSQLManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[self alloc] init];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:databasePath];
        _instanceType.databaseQueue = [[FMDatabaseQueue alloc] initWithPath:path];
    });
    return _instanceType;
}

// 创建表
- (void)creatTable {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"db.sql" ofType:nil];
    NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
       
        BOOL result = [db executeStatements:sql];
        
        if (!result) {
            NSLog(@"创建表失败");
        }
        
    }];
}

@end
